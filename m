Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbYHVJD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbYHVJD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 05:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYHVJDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 05:03:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41918 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbYHVJDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 05:03:19 -0400
Date: Fri, 22 Aug 2008 11:03:18 +0200
From: Pavel Machek <pavel@suse.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fundamental Design Flaw of the Device Driver Model?
Message-ID: <20080822090318.GB6542@atrey.karlin.mff.cuni.cz>
References: <f17812d70808212325m24f25518t5e8dd2fc5e7919b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70808212325m24f25518t5e8dd2fc5e7919b@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fundamental Design Flaw of the Device Driver Model?
> ===================================================
> 
> Sorry for the misleading subject, its purpose is to draw your attention :-)
> The ideas below are preliminary and I hope I'm not making serious mistakes
> here.
> 
> This question has actually been around in my mind for several months, when
> I started to work on some devices with multiple functions. Specifically, a
> Power Management IC (PMIC in short in the following text) usually includes
> LEDs support (charging, indication...) audio, touch screen, power monitoring,
> LDOs, DC-DC bucks, and possibly some others.
> 
> The initial two ideas came into my mind were:
> 
>    1. separate the functions into multiple devices, write a driver for each
>       of these devices

Go for 1.

>    4. An intermediate device with no bus, no driver, no many other things
>       is really not something deserving a "struct device", that's a waste
>       of memory.

Memory is not _that_ expensive, and struct device is not that
big. Adding infrastructure to driver model for supporting this would
also cost you memory, this time in .text segment.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
