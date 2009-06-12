Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbZFLKpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbZFLKpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZFLKpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:45:36 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:44445 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZFLKpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:45:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NHWpvTRP4x5Q4DaVbWDT5JIGJkQwLbAMkGcIOIvwC+7h8KKpZcvNOMPLF41yGSSgBV
         3M2bzaWl+zRCjkiKc2C7BWmYDg9I70XJndOq0gTdpBfUjvVa+E+0EJpNPwrve18u+PE0
         LMtEdeH5BSkv5SuKr9bu5YojyERKCYPd54A+U=
MIME-Version: 1.0
In-Reply-To: <20090612113830.6c21dfc9@lxorguk.ukuu.org.uk>
References: <1244802468-13667-1-git-send-email-vapier@gentoo.org> 
	<20090612113320.73e6f7f1@lxorguk.ukuu.org.uk> <8bd0f97a0906120334v2a1bfabr3af883b5cd1ee3a0@mail.gmail.com> 
	<20090612113830.6c21dfc9@lxorguk.ukuu.org.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 12 Jun 2009 06:45:17 -0400
Message-ID: <8bd0f97a0906120345s61c7216cp1925f05f829a1c3a@mail.gmail.com>
Subject: Re: [PATCH] tty: fix unused warning when TCGETX is not defined
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 06:38, Alan Cox wrote:
>> > If I wasn't so nice I'd just make it and the lack of BOTHER definitions
>> > on platforms error. Really there shouldn't be anyone without the features
>> > defined ;)
>>
>> if i knew a lick about these extended tty pieces, i'd look at hooking them up
>>
>> are these really arch specific ?
>
> The ioctl numbers have to be (although most platforms use the same
> values), and the "BOTHER" definition for arbitary baud rates depends on
> the format of struct termios - which again varies by architecture. Its
> usually the case that CBAUDEX|0 isn't used for anything so we use that
> for BOTHER.

mmm BOTHER is used to get arbitrary speeds right ?  i recall testing
that on Blackfin already so i'm pretty sure that works ...

> Other than the numbering they are not arch specific, so just pick the
> constants for the platform.

the guys who did the original Blackfin arch port simply copied the x86
termios stuff (which actually kind of sucks because it means they
copied the termios2 wart)

wonder if people would get annoyed if i changed the Blackfin headers
to do #include <asm/../../../x86/include/asm/foo.h> ;)

doing a diff between x86 and Blackfin headers shows that
termbits/termios are exact copies (ignoring the #ifdef header
protection) and that the Blackfin ioctls.h is missing:
TIOCGRS485
TIOCSRS485
TCGETX
TCSETX
TCSETXF
TCSETXW
TIOCGHAYESESP
TIOCSHAYESESP
-mike
