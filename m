Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbZJNAbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbZJNAbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 20:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZJNAbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 20:31:19 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:42500 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbZJNAbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 20:31:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kO3cTR3eeVICkJY17FX3lt3UsaFxeu1pu9jtwq+7I9YKXppAqN8egVxmL455UQ/9He
         zQx2DFC/osIZvqzxwfFk4OIjMb5AqgtrmuTvLRGHhPtbOxihpEIIV00tCWyIbIQRU21g
         EJ6FyEYrXzVMePoCvaGhDi1Slz0LvFXCpWU0Q=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0910131040340.3781@localhost.localdomain>
References: <alpine.LFD.2.00.0910122350140.3658@localhost.localdomain> 
	<alpine.LFD.2.00.0910130007240.3658@localhost.localdomain> 
	<8bd0f97a0910130054v43fd9fbcv5316a5194ced4bfc@mail.gmail.com> 
	<alpine.LFD.2.00.0910131027090.3781@localhost.localdomain> 
	<8bd0f97a0910130135s152ee984sc8499766d3c0ef86@mail.gmail.com> 
	<alpine.LFD.2.00.0910131040340.3781@localhost.localdomain>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 13 Oct 2009 20:30:22 -0400
Message-ID: <8bd0f97a0910131730s49d3c1bcld02286e3cffef125@mail.gmail.com>
Subject: Re: [PATCH 1/6 RFC] arch/blackfin/kernel/process.c: Remove the BKL 
	from sys_execve
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 04:41, John Kacur wrote:
> On Tue, 13 Oct 2009, Mike Frysinger wrote:
>> On Tue, Oct 13, 2009 at 04:27, John Kacur wrote:
>> > On Tue, 13 Oct 2009, Mike Frysinger wrote:
>> >> On Mon, Oct 12, 2009 at 18:33, John Kacur wrote:
>> >> > This looks like a cut-and-paste job.
>> >> > For example, compare this function to sys_execve in
>> >> > arch/x86/kernel/process_64.c
>> >> >
>> >> > and it is almost line by line the same, except the one in x86 nolonger has the
>> >> > big kernel lock. All of the functions called between the lock are generic
>> >> > and not specific to blackfin - thus, I believe it is safe to remove the
>> >> > bkl here.
>> >>
>> >> and it still boots/runs fine, so np here
>> >> Acked-by: Mike Frysinger <vapier@gentoo.org>
>> >
>> > Cool - are you testing on one of those nifty smp (or smp-like) blackfins?
>>
>> no, this was a uniproc.  i could try a SMP Blackfin if you think it'll
>> make a difference.
>
> Well - hopefully it won't make a difference, but if there are problems,
> then that is where they will show up.

it seems that the Blackfin SMP code is currently broken during boot,
so i'll have to wait until that is fixed ;)

i would just queue this in the mean time since, as you said, the code
is generic (sounds like a case for moving sys_execve to common code)
and there shouldnt be any issues.
-mike
