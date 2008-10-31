Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbYJaSMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbYJaSMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 14:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYJaSL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 14:11:57 -0400
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:59761 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751103AbYJaSL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 14:11:56 -0400
Message-ID: <490B4A6A.7020200@vlnb.net>
Date: Fri, 31 Oct 2008 21:11:54 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x51/0x66()
References: <4901F375.3020202@vlnb.net> <200810282342.05172.nickpiggin@yahoo.com.au> <49076A36.5040802@vlnb.net> <200810291125.31547.nickpiggin@yahoo.com.au>
In-Reply-To: <200810291125.31547.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Wednesday 29 October 2008 06:38, Vladislav Bolkhovitin wrote:
>> Nick Piggin wrote:
>>> On Saturday 25 October 2008 03:10, Vladislav Bolkhovitin wrote:
>>>> Hi,
>>>>
>>>> During recent debugging session of my SCSI target SCST
>>>> (http://scst.sf.net) I noticed many
>>>>
>>>> WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x51/0x66()
>>>>
>>>> messages in kernel log on the initiator. I attached the full log of
>>>> several of them.
>>>>
>>>> My target was buggy and I was working on fixing it, but I suppose Linux
>>>> should handle such failures more gracefully. In all the cases the target
>>>> had one type of failure: it "ate" a SCSI command and never returned
>>>> result of it.
>>> Right. This is one of the warnings I see in my fault-injection testing.
>>> It is fixed by my patch to clean up and improve the page and buffer
>>> error handling in the vm/fs.
>> Can you specify which patch you referring? Is it in 2.6.27?
> 
> It's just an RFC at the moment which I posted to fsdevel. Not in 2.6.27.

I see. I'm looking forward to see it in 2.6.28 or .29. This is really a 
needed work.

BTW, have you even seen in your fault-injection testing that after 
receiving a failure from a SCSI device during heavy load ext3 file 
system mounted on it gets corrupted and journal replay on remount 
doesn't repair it, only manual e2fsck helps? I've many times seen that, 
including cases when the target was remaining up and fully functional. 
See, e.g., "MOANING MODE ON" part in 
http://marc.info/?l=linux-scsi&m=121932252324432&w=2. I haven't checked 
that case since then, although I see such corruptions quite often. But 
in all them I can't so clearly say that it isn't a target's failure.

Vlad

