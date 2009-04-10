Return-Path: <linux-kernel-owner+w=401wt.eu-S934854AbZDJTwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934854AbZDJTwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 15:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762726AbZDJTwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 15:52:36 -0400
Received: from www.tglx.de ([62.245.132.106]:36933 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757118AbZDJTwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 15:52:35 -0400
Date: Fri, 10 Apr 2009 21:51:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Sam Ravnborg <sam@ravnborg.org>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, josh@freedesktop.org
Subject: Re: [PATCH -tip] x86: acpi/sleep.c saved_magic fix overflow
In-Reply-To: <1239391016.3169.49.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0904102127180.21577@localhost.localdomain>
References: <1239385015.3169.15.camel@ht.satnam>  <20090410175545.GB16843@elf.ucw.cz>  <20090410191334.GA25336@uranus.ravnborg.org> <1239391016.3169.49.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Apr 2009, Jaswinder Singh Rajput wrote:
> Sorry, I was confused by this sparse warning on 64 bit box:
> 
> CHECK   arch/x86/kernel/acpi/sleep.c
>  arch/x86/kernel/acpi/sleep.c:107:16: warning: constant 0x123456789abcdef0 is so big it is long
> 
> atleast I found problem in sparse ;-)

Sigh. There is no problem in sparse. The problem is between keyboard
and chair.

Care to read what the warning says ?

     warning: constant 0x123456789abcdef0 is so big it is long

It needs to be: 0x123456789abcdef0L

Seriously, this kind of mechanical "fix" warnings no matter what and
without actually understanding the issues is more than counter
productive.

The point is, you force people into wasting a lot of time into what
should have been handled in 10 seconds. This is not efficient at all
and you need to improve your ways of communicaton and be more careful
about the patches you submit.

Thanks,

	tglx
