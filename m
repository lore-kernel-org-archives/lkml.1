Return-Path: <linux-kernel-owner+w=401wt.eu-S1752472AbZEVGDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbZEVGDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 02:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZEVGD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 02:03:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45725 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZEVGDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 02:03:25 -0400
Date: Tue, 19 May 2009 22:30:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Peter Feuerer <peter@piie.net>
Cc: petkovbb@gmail.com, LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Message-ID: <20090519203015.GA1362@ucw.cz>
References: <cone.1240858632.795110.5316.1000@onepiie> <20090428072519.GA12170@liondog.tnic> <1240913055.29860.14.camel@maxim-laptop> <cone.1240949852.549814.7466.1000@mentalhome> <1240950704.3781.12.camel@maxim-laptop> <cone.1241299309.265715.3948.1000@mentalhome> <20090503184617.GA3555@liondog.tnic> <cone.1241648222.299676.7476.1000@mentalhome> <20090509171432.GA31126@liondog.tnic> <cone.1242065107.695268.13534.1000@onepiie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cone.1242065107.695268.13534.1000@onepiie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> the more I'm looking at the driver, the more I get annoyed by that
>> user/kernel mode operation split. Remind me again why the driver should
>> be loaded and not started automatically but the user should be required
>> to activate it explicitly?
>
> The idea of not starting the module in kernel mode was from Matthew. And 
> he stated that it could harm the hardware when software controls the fan  
> instead of the BIOS. It may also be possible, that the warranty gets 

Well... hw is usually designed to protect itself.

>> That's not so optimal, I'd say. The kernel module should _replace_
>> the userspace program, not work alongside it, since the last is flaky
>> and unreliable, and this was the main reason the kernel module was
>> introduced in the first place - to control the fan from kernel space,
>> which is the more sane choice.
>
> The main reason to do this in kernel was the availabilty of atomic ec- 
> read and write functions. But I agree with you that either kernel or BIOS 
> should control the fan and not a userspace tool. I added the user mode 
> just because it wasn't really much more code than just an implementation 
> of the enable/disable functionality.

Kernels crash, too, just like userspace does. It would still make
sense to allow userspace to increase fan speed.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
