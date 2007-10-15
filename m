Return-Path: <linux-kernel-owner+w=401wt.eu-S1759403AbXJOVHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403AbXJOVHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbXJOVHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:07:43 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45134 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752463AbXJOVHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:07:42 -0400
X-Sasl-enc: JT53ll6oGP8QZl+HalwepsLcFvwmiZpjVCajOJeHdADK 1192482461
Date: Mon, 15 Oct 2007 19:07:37 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jeremy Katz <katzj@redhat.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       davej@redhat.com
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Message-ID: <20071015210737.GA15293@khazad-dum.debian.net>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192481110-9299-1-git-send-email-katzj@redhat.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Jeremy Katz wrote:
> There are standard keycodes for brightness and volume; map the events to
> emit them so that things work properly

NAK.  It is the completely wrong thing to do for IBM thinkpads which process
volume and brightness completely in firmware.

And the input subsystem maintainer has made it extremely clear in various
threads that the input devices are *not* to be used as a notification
service for on-screen-display or other such stuff.  If you send volume and
brightness *key* events to userspace, it is supposed to act on them and
raise/lower brightness/volume, which is the wrong thing to do on thinkpads.
Never mind that HAL is ignoring the input maintainer's directions and
violating this.

We should fix the backlight class to be more useful and support poll() or
somesuch, for userspace to track the backlight level in a resource-friendly
way for OSD (the only sane thing to do on an IBM thinkpad with such events).
And an ALSA mixer to provide a proper path to the thinkpad-acpi volume
functionality is also in my schedule for 2.6.25.

As for Lenovo thinkpads, brightness control is to be processed by the ACPI
video module, so brightness hot keys are not to be reported by default there
either.  I am not so sure about the volume keys, but your patch touches the
IBM keymap *and* you provide no testing information for the various Lenovo
models, so I have to NAK it as well until more information is available.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
