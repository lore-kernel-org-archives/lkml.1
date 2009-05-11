Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbZEKQHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbZEKQHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbZEKQHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:07:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41894 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZEKQHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:07:36 -0400
Message-ID: <4A084C36.3010808@zytor.com>
Date: Mon, 11 May 2009 09:03:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vgoyal@redhat.com" <vgoyal@redhat.com>,
       "hbabu@us.ibm.com" <hbabu@us.ibm.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "Huang\, Ying" <ying.huang@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "sam@ravnborg.org" <sam@ravnborg.org>
Subject: Re: RFC: x86: relocatable kernel changes (revised spec)
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>	<m14ovwz8ua.fsf@fess.ebiederm.org> <4A03C3BB.3070401@intel.com>	<m1tz3wgk3n.fsf@fess.ebiederm.org> <4A047E53.8040003@intel.com>	<4A07B534.8080606@zytor.com> <m1vdo7hn2i.fsf@fess.ebiederm.org>
In-Reply-To: <m1vdo7hn2i.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
>> +Field name:	init_size
>> +Type:		read
>> +Offset/size:	0x25c/4
>> +
>> +  This field indicates the amount of linear contiguous memory starting
>> +  at the kernel load address (rounded up to kernel_alignment) that the
>> +  kernel needs before it is capable of examining its memory map.  This
>> +  is not the same thing as the total amount of memory the kernel needs
>> +  to boot, but it can be used by a relocating boot loader to help
>> +  select a safe load address for the kernel.
> 
> This wording is a bit unclear.
> 
> Can we finally say that it is safe to put the initrd immediately after
> the kernel?
> 

I *believe* we can, as the brk limit checking should catch overruns.
The only question is whether or not there will me memory allocated off
the memory map before the initrd is reserved; I *think* the answer is no
but I haven't done the audit.

> The rounding up part of that comment is unclear.

The rounding up was to reflect the automatic moving upwards from the
load address to the next kernel_alignment datum.

> Peter did your implementation of init_size take into account the maximum expansion
> during decompression?  At a quick glance at your previous patches I couldn't
> tell.  I know were in that direction with zoffset.h and voffset.h but I don't
> recognize the formula for where I put the pic decompressor in your calculation
> of this.

It does take it into account.  The pic decompressor is located at
(ZO_)z_extract_offset; the actual formula moved into mkpiggy.c.

I have regenerated the tip:x86/kbuild-phys branch to be only cleanups
(with the intent of putting the policy changes cleanly on top), and much
better structured.  I hadn't originally expected this to turn into so
much of a cleanup effort.

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=shortlog;h=x86/kbuild-phys

This checkin, in particular, should answer that question, I believe:

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=02a884c0fe7ec8459d00d34b7d4101af21fc4a86

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

