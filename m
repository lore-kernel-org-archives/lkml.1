Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277Ab0AZUKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0AZUKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 15:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877Ab0AZUKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 15:10:08 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57408 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab0AZUKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 15:10:07 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B5F4C10.9040300@s5r6.in-berlin.de>
Date: Tue, 26 Jan 2010 21:09:52 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: =?UTF-8?B?0JjQu9GM0Y8g0JHQsNGB0LjQvQ==?= <basinilya@gmail.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: net: fix panic in fwnet_write_complete
References: <574312453.20100114002526@gmail.com> <4B4E4D73.5060100@s5r6.in-berlin.de> <4B4E4FD7.9060403@s5r6.in-berlin.de> <4B53291A.5050901@s5r6.in-berlin.de> <1833218156.20100118151651@gmail.com> <4B547154.40700@s5r6.in-berlin.de> <tkrat.a8b022df2a5d588d@s5r6.in-berlin.de> <4B54FFF9.9000906@s5r6.in-berlin.de>
In-Reply-To: <4B54FFF9.9000906@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> My own testing on a dual core box --- peered with another Linux box
> which ran the older eth1394 --- worked OK so far for transfers of
> massive files (> 4 GiB) back and forth via FTP and ssh running on a text
> console.
> 
> But in my first attempt to use FTP on X11 --- i.e. with more concurrent
> interrupt sources --- the firewire-net box crashed very soon.  In that
> test I used Dolphin of KDE as FTP client, and the crash already happened
> after Dolphin had loaded and displayed the remote home directory and was
> peeking into files for preview data.  I got the following trace:
> 
> ------------: cut here ]------------			
> kernel: BUG at mm/slab.c:2885!  			
[...]
> EIP: is at cache_free_debugcheck+0x1e8/0x2e8		
[...]
> Call: Trace:
> ? __kfree_skb+0x6e/0x71
> ? kmem_cache_free+0x56/0xb0
> ? __kfree_skb+0x6e/0x71
> ? kfree_skb+0x2b/0x2d
> ? unix_stream_recvmsg+0x3c3/0x48d
> ? file_read_actor+0x74/0xcc
> ? sock_aio_read+0xf2/0x107
> ? do_sync_read+0x89/0xc7

Hi Илья,

I am going to send a pull request for some other unrelated firewire
fixes to Linus about tomorrow.

firewire-net on the other hand needs still more work than my
fwnet_write_complete patch since you and I now get these kmem cache
corruption related bugs.

What is your impression --- does this first incomplete fix decrease the
likelihood of crashes enough to make it worth to include it in a pull
request already?  I haven't done more extensive firewire-net tests since
last week yet, hence it is hard to tell for me how severe the new issue
is in practical use.

(Also, I have no idea yet whether I will be quick or slow to find this
other problem and whether it can be fixed in a manner that is suitable
for a mainline merge before 2.6.33 is going to be released.)
-- 
Stefan Richter
-=====-==-=- ---= ==-=-
http://arcgraph.de/sr/
