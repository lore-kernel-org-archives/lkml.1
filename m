Return-Path: <linux-kernel-owner+w=401wt.eu-S1762351AbYFDX3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762351AbYFDX3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 19:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbYFDX3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 19:29:38 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:27601 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbYFDX3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 19:29:37 -0400
X-Spam-Flag: NO
X-Spam-Score: -8.389
Message-ID: <48472551.9020202@tremplin-utc.net>
Date: Thu, 05 Jun 2008 01:29:21 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.14) Gecko/20080504 Mandriva/2.0.0.14-1mdv2009.0 (2009.0) Thunderbird/2.0.0.14 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
Cc: Andrew Morton <akpm@osdl.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Yan Burman <burman.yan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       HWMON <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2.6.25.4]  hwmon: HP Mobile Data Protection System 3D
 ACPI driver -- please review!
References: <1212235533.3815.5.camel@localhost> <4846EBF5.2030406@tremplin-utc.net> <20080604230326.GA30475@elf.ucw.cz>
In-Reply-To: <20080604230326.GA30475@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

05-06-08 01:03, Pavel Machek wrote/a écrit:
> Hi!
>>> 3) Makes it possible to power the device off.
> 
> But this part is what I don't understand. powering off does not seem
> to belong there. Why can't you just use acpi to power down?
Not sure what you mean. Are you saying acpi has already a user interface
to power up/down a device? If so, I'm not aware of it, is it in /sys ?
Or did you mean that there is already a kernel api to turn on/off a
device via acpi, no need to access the device directly?

That said, this special /sys interface to power the device off is
probably going to be used rarely. It was put there because it is costly
to wake the device up each time we want to read it. What I could do is
put a timer to turn the device off after 10s of non-usage, and power it
on automatically again as soon as the user wants to read some info. That
would permit to remove this interface.

Eric

