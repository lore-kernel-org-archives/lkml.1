Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067Ab0AaJor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab0AaJor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 04:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564Ab0AaJoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 04:44:46 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53773 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab0AaJop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 04:44:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-mailer:reply-to:x-priority:message-id:to:cc:subject
         :in-reply-to:references:mime-version:content-type
         :content-transfer-encoding;
        b=TAoPXTY4Sm+sHAxJ7IFQerVR2eNiMGReEkVS0rPHMOG1SqZ4d2wQku7TELw192O4PT
         xPMvhebK5DXISmEVQ0JEDLta8EZSlgt/DVOELv8zb3M8Lv/BeRNkjl6OGDQGccpmnPA2
         VBVcIAL7zorpxmH6svacMXNXn0FC/hITYPQKA=
Date: Sun, 31 Jan 2010 12:45:28 +0300
From: =?utf-8?B?0JjQu9GM0Y8g0JHQsNGB0LjQvQ==?= <basinilya@gmail.com>
X-Mailer: Voyager (v3.99.4) Professional
Reply-To: =?utf-8?B?0JjQu9GM0Y8g0JHQsNGB0LjQvQ==?= <basinilya@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <221196491.20100131124528@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re[2]: [PATCH] firewire: net: fix panic in fwnet_write_complete
In-Reply-To: <4B5F4C10.9040300@s5r6.in-berlin.de>
References: <574312453.20100114002526@gmail.com> <4B4E4D73.5060100@s5r6.in-berlin.de> <4B4E4FD7.9060403@s5r6.in-berlin.de> <4B53291A.5050901@s5r6.in-berlin.de> <1833218156.20100118151651@gmail.com> <4B547154.40700@s5r6.in-berlin.de> <tkrat.a8b022df2a5d588d@s5r6.in-berlin.de> <4B54FFF9.9000906@s5r6.in-berlin.de> <4B5F4C10.9040300@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SR> Stefan Richter wrote:
>> My own testing on a dual core box --- peered with another Linux box
>> which ran the older eth1394 --- worked OK so far for transfers of
>> massive files (> 4 GiB) back and forth via FTP and ssh running on a text
>> console.
>> 
>> But in my first attempt to use FTP on X11 --- i.e. with more concurrent
>> interrupt sources --- the firewire-net box crashed very soon.  In that
>> test I used Dolphin of KDE as FTP client, and the crash already happened
>> after Dolphin had loaded and displayed the remote home directory and was
>> peeking into files for preview data.  I got the following trace:
>> 
>> ------------: cut here ]------------                  
>> kernel: BUG at mm/slab.c:2885!                        
SR> [...]
>> EIP: is at cache_free_debugcheck+0x1e8/0x2e8          
SR> [...]
>> Call: Trace:
>> ? __kfree_skb+0x6e/0x71
>> ? kmem_cache_free+0x56/0xb0
>> ? __kfree_skb+0x6e/0x71
>> ? kfree_skb+0x2b/0x2d
>> ? unix_stream_recvmsg+0x3c3/0x48d
>> ? file_read_actor+0x74/0xcc
>> ? sock_aio_read+0xf2/0x107
>> ? do_sync_read+0x89/0xc7

SR> Hi Илья,

SR> I am going to send a pull request for some other unrelated firewire
SR> fixes to Linus about tomorrow.

SR> firewire-net on the other hand needs still more work than my
SR> fwnet_write_complete patch since you and I now get these kmem cache
SR> corruption related bugs.

SR> What is your impression --- does this first incomplete fix decrease the
SR> likelihood of crashes enough to make it worth to include it in a pull
SR> request already?  I haven't done more extensive firewire-net tests since
SR> last week yet, hence it is hard to tell for me how severe the new issue
SR> is in practical use.

SR> (Also, I have no idea yet whether I will be quick or slow to find this
SR> other problem and whether it can be fixed in a manner that is suitable
SR> for a mainline merge before 2.6.33 is going to be released.)

Hi. Have just found 4 letters from you in gmail spam bin, including
this one. Your fix does decrease the chance of crash. Without the fix
crashes randomly occured within 3 minutes. With the fix - only after
10 minutes of copying. These 2 bugs are probably unrelated.

-- 

