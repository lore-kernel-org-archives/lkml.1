Return-Path: <linux-kernel-owner+w=401wt.eu-S1757680AbYKVAwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbYKVAwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 19:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbYKVAv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 19:51:59 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:25779 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbYKVAv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 19:51:59 -0500
X-Spam-Flag: NO
X-Spam-Score: -8.097
Message-ID: <492757A8.6010509@tremplin-utc.net>
Date: Sat, 22 Nov 2008 01:51:52 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.18) Gecko/20081120 Mandriva/2.0.0.18-1mdv2009.1 (2009.1) Thunderbird/2.0.0.18 Mnenhy/0.7.5.0
MIME-Version: 1.0
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@suse.cz>,
       linux-kernel@vger.kernel.org, trenn@suse.de, rpurdie@rpsys.net,
       hmh@hmh.eng.br
Subject: Re: HP accelerometer: split chip handling from HP ACPI interface
References: <20081121212121.GA7222@elf.ucw.cz> <20081121160022.86020953.akpm@linux-foundation.org> <49275194.6070604@tremplin-utc.net>
In-Reply-To: <49275194.6070604@tremplin-utc.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Éric Piel schreef:
> Andrew Morton schreef:
>> On Fri, 21 Nov 2008 22:21:21 +0100
>> Pavel Machek <pavel@suse.cz> wrote:
>>
>>> This patch splits handling between chip-specific lis3lv02d and HP/ACPI
>>> specific hp_accel.c.
>> umm, so?  What reason does anyone have for applying it?
> Here is the log I have for the (old version) of pavel's patch:
> 
> The sensor can be accessed via various buses. In particular, SPI, I²C
> and, on HP laptops, via a specific ACPI API (the only one currently
> supported). Separate this latest platform from the core of the sensor
> driver to allow support for the other bus type. The second, and more
> direct goal is actually to be able to merge this part with the
> hp-disk-leds driver, which has the same ACPI PNP number.
> 
> 
> I'll try to follow with a patch doing the merge of the hp-disk-leds
> driver, so that everything makes sense...
Actually, I mistook, Pavel also included some led stuff in this patch.
That doesn't look right, especially as the led driver is not removed!
Following are two patches (nearly all work done by Pavel) which should
make this enhancement much clearer:
- Separate the HP ACPI support from the core
- Merge the led support and with the rest of the HP ACPI support

The final semantic of these two patches should be equivalent to the one
provided by Pavel (with some Kconfig bonus).

See you,
Eric
