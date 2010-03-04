Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab0CDRwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:52:13 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51261 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab0CDRwL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:52:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=i94zRczABPrgAreKV2KHvl+M9x/KjFFhVYaApqeeq6Hih2gKaik/VSTDeeX+1yx3iv
         P68cyjVWTtSPtDB40J0qpvPFBc8I5n3SDGvF8O8na2xU0kQW8yVoi61pQ4tANr2w0PCu
         Ui1Rm2FL900jsHl3YGl/ubYZ7z0SDWxqrvZLk=
MIME-Version: 1.0
In-Reply-To: <b4198de60910190853k54267f9flcf6453d6e23f6da3@mail.gmail.com>
References: <1255939868-5050-1-git-send-email-mcree@orcon.net.nz> 
	<b4198de60910190853k54267f9flcf6453d6e23f6da3@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 4 Mar 2010 12:51:49 -0500
Message-ID: <8bd0f97a1003040951x52b0a2e5m8b724245ab773436@mail.gmail.com>
Subject: Re: Unimplemented syscalls on Alpha
To: Matt Turner <mattst88@gmail.com>
Cc: Michael Cree <mcree@orcon.net.nz>, linux-alpha@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 10:53, Matt Turner wrote:
> On Mon, Oct 19, 2009 at 4:11 AM, Michael Cree wrote:
>> I couldn't but help notice the increasing number of unimplemented syscalls
>> on the Alpha architecture.  I thought I might poke around to see what might
>> be required to get these implemented and got a pleasant surprise when it
>> seems some only need an entry in the syscall table.  Indeed, the patch in
>> reply to this message gets preadv and pwritev going -- tested with the
>> sample program at http://lkml.org/lkml/2009/4/6/535.
>
> Cool. I was looking into doing this, but I didn't know how to test the syscalls.
>
> I tried to keep a list of missing syscalls here,
> http://alphalinux.org/wiki/index.php/TODO_List but as you can see it's
> already out of date.
>
>> I am happy to write patches to wire up more of the syscalls, but I am
>> wondering which ones are as straightforward as the preadv/pwritev case?
>> That is, do any require extra programming other than the syscall table?  Do
>> I need to get the entries in the syscall table in the same order as other
>> architectures?
>
> I'm curious and unsure about this too. Patches would be great. I think
> we should figure out who we need to CC to get patches into the kernel,
> as neither of our maintainers have any sort of Alpha tree. I've
> noticed a few patches submitted to this list have never made it into
> the kernel, as well, maybe we should start an alpha tree?

typically if the sys_xxx entry is in common code, you dont need to
implement arch-specific stuff.  just hook them up in the system call
table.  afaik, preadv/pwritev fall into this category.

> The entries do not need to be in the same order of have the same
> number as other architectures, just once you set the number you cannot
> change it (without breaking the ABI).

correct ... and breaking the ABI is unacceptable
-mike
