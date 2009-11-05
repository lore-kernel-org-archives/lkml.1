Return-Path: <linux-kernel-owner+w=401wt.eu-S1751471AbZKEHDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbZKEHDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 02:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbZKEHDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 02:03:10 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:49312 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbZKEHDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 02:03:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RlHCh7yh/uAr3UPnd2FAl6epr0gYKaMyWOZ+fwJZCcdwZpFpgrBTYJcWi2bkc3SJDn
         vgwFU2c+NVs7H/A4M+BmSuT05k7hjPmv3zyLxEQCQoVR7EXu47o2pJjzVbECi7cH8Hyi
         Y5kMhylVXTkN/QoIh6xhc+MNfqzmNXqblzklU=
MIME-Version: 1.0
In-Reply-To: <1256797453.4362.61.camel@ben-desktop>
References: <3a665c760910270627u784d43b8t2978731110c920a4@mail.gmail.com>
	 <3a665c760910270723l6989539er7e820d630cce51ac@mail.gmail.com>
	 <1256797453.4362.61.camel@ben-desktop>
Date: Thu, 5 Nov 2009 15:03:14 +0800
Message-ID: <3a665c760911042303p7cdbd99frfeda5a3c3cb68ccb@mail.gmail.com>
Subject: Re: kernel panic about kernel unaligned access
From: loody <miloody@gmail.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all:

2009/10/29 Ben Nizette <bn@niasdigital.com>:
> On Tue, 2009-10-27 at 22:23 +0800, loody wrote:
>> Dear all:
>> I use kernel 2.6.18 and I get the kernel panic as below:
>
> Very old kernel, you're unlikely to get good responses.
>
>> 1. what does "Not tainted" mean?
>
> You haven't loaded a closed-source module, the system hasn't crashed
> before and a few other things.  Pretty much that your system was in good
> shape before the bug
>
>> 2. I grep the kernel and I find the above message comes from do_ade in
>> unaligned.c, If I guess correctly.
>>    but from the call trace I cannot find out who call it.
>>    who and how kernel pass the information to do_ade?
>
> No-one calls it, it's an exception handler invoked when an unaligned
> access is attempted.  Your question should be "on which assembler
> instruction is the unaligned access attempted" and you can find that out
> as below
>
>> 3. as far as i know, inode is the data structure we used to record file.
>
> Well, its a structure which holds metadata about files, yes
>
>> From what information in the inode I can find out the file name the
>> writeback_inodes try to write?
>
> Not with just this information; you'd need additional debug output, but
> even then I very much doubt that information would help you
>
>> 4. take  [<87189564>] preempt_schedule+0x68/0xac for example, what
>> does "0xac" mean?
>
> That's the symbol size. 0x68 is the offset in to preempt_schedule and
> probably more useful for you.  With that info, your vmlinux and gdb you
> can get the offending asm instruction.
>
> All that said, it's such an old kernel you're unlikely to get much help
> actually fixing the bug, you're much better off to upgrade if there's
> any chance of it.
>
>        --Ben.
I have one question.
If we use mmap in usermode to map HW registers under mips machine,
what is the proper flag I should use in mmap or open?
Since I find the problem seems come from some application try to
access registers by mmaping.
appreciate your help,
miloody
