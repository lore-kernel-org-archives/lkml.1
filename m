Return-Path: <linux-kernel-owner+w=401wt.eu-S1760915AbXKAOwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915AbXKAOwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbXKAOvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:51:31 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:32628 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbXKAOv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:51:29 -0400
Message-ID: <4729E7DB.8040300@emc.com>
Date: Thu, 01 Nov 2007 10:51:07 -0400
From: Ric Wheeler <ric@emc.com>
Reply-To: ric@emc.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Mike Waychison <mikew@google.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/1] Drop CAP_SYS_RAWIO requirement for FIBMAP
References: <20071025230758.945535769@crlf.corp.google.com> <20071029190813.GB7742@ucw.cz>
In-Reply-To: <20071029190813.GB7742@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.51425
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Pavel Machek wrote:
> Hi!
> 
>> Remove the need for having CAP_SYS_RAWIO when doing a FIBMAP call on an open file descriptor.
>>
>> It would be nice to allow users to have permission to see where their data is landing on disk, and there really isn't a good reason to keep them from getting at this information.
> 
> I believe it is to prevent users from intentionally creating extremely
> fragmented files...
> 
> You can read 60MB in a second, but fragmented 60MB file could take
> 10msec * 60MB/4KB = 150 seconds. That's factor 150 slowdown...
> 
> ...but I agree that SYS_RAWIO may be wrong capability to cover this.
> 
> 							Pavel

I don't see how restricting FIBMAP use helps prevent fragmentation since FIBMAP 
just allows you to see what damage was already done.

You can create nicely fragmented files simply by having multiple threads writing 
concurrently to one or more files in the same directory (depending on the file 
system, allocation policy, etc).

ric

