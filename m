Return-Path: <linux-kernel-owner+w=401wt.eu-S1752763AbYJYKmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbYJYKmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 06:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbYJYKml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 06:42:41 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:27477 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbYJYKmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 06:42:40 -0400
X-Spam-Flag: NO
X-Spam-Score: -9.389
Message-ID: <4902F817.4050108@tremplin-utc.net>
Date: Sat, 25 Oct 2008 12:42:31 +0200
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.17) Gecko/20080929 Mandriva/2.0.0.17-2mdv2009.0 (2009.0) Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
Cc: Thomas Renninger <trenn@suse.de>, akpm@linux-foundation.org,
       burman.yan@gmail.com, rpurdie@rpsys.net,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>
Subject: leds-hp-disk vs lis3lv02d
References: <200810162255.m9GMtKj4001733@imap1.linux-foundation.org> <200810192106.15905.trenn@suse.de> <20081019204819.GC1465@ucw.cz>
In-Reply-To: <20081019204819.GC1465@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek schreef:
> Hi!
> 
>> shouldn't this one be integrated into Eric's/Yan's driver?
> 
> It is separate piece of hardware, completely unrelated to lids3v
> chip. No, it should not be integrated, but I'll makesure they work
> toggether well.
Hello,
I think I talked too fast: it seems impossible to have both drivers
(leds-hp-disk and lis3lv02d) working at the same time. Only the first
driver loaded is used.

After a little look at it, I think it comes from the fact that both
drivers are assigned to the same MODALIAS (HPQ0004). The ACPI PNP
(through the generic bus infrastructure) only declare the device to one
of the drivers supporting it, not all of them.

How can I tell to ACPI that it should load both drivers for the same PNP
ID match?

Eric
