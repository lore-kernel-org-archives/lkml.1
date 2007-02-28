Return-Path: <linux-kernel-owner+w=401wt.eu-S932371AbXB1Vi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbXB1Vi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932374AbXB1Vi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:38:58 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4973 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932371AbXB1Vi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:38:57 -0500
Date: Wed, 28 Feb 2007 21:38:04 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Rudolf Marek <r.marek@assembler.cz>,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-ID: <20070228213803.GA4877@ucw.cz>
References: <45D5EA88.7090300@redhat.com> <45D6DDCE.5050803@assembler.cz> <45D7461A.2040808@redhat.com> <20070218183805.5a4fd813.khali@linux-fr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070218183805.5a4fd813.khali@linux-fr.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Well I had an idea after looking at k8temp -- why not make it default to
> > doing only reads from the sensor?  You'd only get information from whatever
> > core/sensor combination that ACPI had last used, but it would be safe.
> 
> ACPI is broken here, not k8temp, so let's fix ACPI instead. ACPI
> doesn't conflict with only k8temp, but with virtually all hardware
> monitoring drivers, all I2C/SMBus drivers, and probably other types of
> drivers too. We just can't restrict or blacklist all these drivers
> because ACPI misbehaves.

Oops, sorry about that but no, that will not work.

There's piece of paper, called ACPI specification, and we are
following it.

Bug is not in our implementation.

Bug is in the ACPI specs... it does not explicitely allow you to go
out and bitbang i2c, and you do it, and you get problems.

Now, you may try to change specs to be hwmon-friendly... good luck.

But currently hw manufacturers follow ACPI specs, so we have to follow
it, too; bad luck for hwmon. BIOS hiding smbus from you is good hint
you are doing something wrong...?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
