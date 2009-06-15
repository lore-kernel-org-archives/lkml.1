Return-Path: <linux-kernel-owner+w=401wt.eu-S1765325AbZFOSwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765325AbZFOSwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761282AbZFOSv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:51:59 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38815 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759064AbZFOSv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:51:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=fNAGrNpZTX1XBgiunKZI9VcwNIFw/w0VffgroekKDnyXXWhngpMpTzoGy45e/wa7X
	VcxuxIh/8Onhq70Rb0PeA==
MIME-Version: 1.0
In-Reply-To: <20090615182850.GA10490@elf.ucw.cz>
References: <1245033557-10968-1-git-send-email-swetland@google.com>
	 <1245033557-10968-2-git-send-email-swetland@google.com>
	 <1245033557-10968-3-git-send-email-swetland@google.com>
	 <1245033557-10968-4-git-send-email-swetland@google.com>
	 <20090615132248.GB14555@elf.ucw.cz>
	 <a55d774e0906151125h36ee7c36yb9ecf5fb3fb8e41b@mail.gmail.com>
	 <20090615182850.GA10490@elf.ucw.cz>
Date: Mon, 15 Jun 2009 11:51:57 -0700
Message-ID: <a55d774e0906151151p223895b1pc01be38e1d0e9358@mail.gmail.com>
Subject: Re: [PATCH 3/3] [ARM] msm: add minimal board file for HTC Dream 
	device
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 11:28 AM, Pavel Machek<pavel@ucw.cz> wrote:
> (Now... I'm trying to figure out how leds are set up. It seems that
> there are two classes -- leds-gpio, which is backlights, and 4colored
> led. I'd like to use 4colored led for debugging... Unfortunately
> drivers/leds/leds-cpld.c is quite "interesting" (and really abuses
> interface at least with "blink" file). Is there easy way to turn some
> light manually, best something that works early and can be used for
> debugging?)

The 4color LED is controlled by an I2C led controller, so it's a bit
of a pain to interact with very early on.

There are LED backlights behind the keyboard and the buttons on the
"chin" of the device, controlled by the CPLD (see
TROUT_GPIO_QTKEY_LED_EN and TROUT_GPIO_UI_LED_EN and and the cpld gpio
stuff in board-trout-gpio.c).

This is actually another reason why I'd actually prefer to stick with
trout at least inside the board-dream-* files... just a lot of code
that uses this name that's we've been working with for a year or so.
Renaming the files is trivial and updating the config options is easy
too, but it gets to be a lot of shuffling around to keep changing the
names internally.  A lot of hardware has names used be the
developers/manufacturers/etc that don't match the product names (HTC
calls "magic" sapphire, for example, and the board files reflect
that), and of course these devices have different names in different
markets too.

Brian
