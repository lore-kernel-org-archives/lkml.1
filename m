Return-Path: <linux-kernel-owner+w=401wt.eu-S965256AbXBZQEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965256AbXBZQEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:04:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbXBZQEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:04:05 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56051 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbXBZQEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:04:02 -0500
X-Sasl-enc: jkLJ1jqI/wCsFhpuYDkRvxmL5PLI0G7Btdm81WSdWtBM 1172505841
Date: Mon, 26 Feb 2007 13:03:54 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc1 dims my LCD
Message-ID: <20070226160354.GC2909@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz> <1172490091.5824.30.camel@localhost.localdomain> <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz> <20070226142157.GA2909@khazad-dum.debian.net> <1172501357.5824.91.camel@localhost.localdomain> <Pine.LNX.4.64.0702261617240.10496@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702261617240.10496@twin.jikos.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007, Jiri Kosina wrote:
> Now regarding the patch - at the time when the dim happened previously, 
> currently there is a observable blink (after which the brightness is 
> correct). I have put some debugging printk() into fb_notifier_callback(), 
> and it turns out that on FB_EVENT_CONBLANK, there are two successive calls 
> to backlight_update_status(), second immediately following the first one:
> 
> Feb 26 15:11:14 thunder kernel: calling backlight_update_status() with bd->props.fb_blank == 1, bd->props.brightness == 0
> Feb 26 15:11:14 thunder kernel: calling backlight_update_status() with bd->props.fb_blank == 0, bd->props.brightness == 0

This should cause *no* blink. It is setting brightness to zero anyway, which
is all ibm-acpi cares about (without a patch I will be sending in soon).
And ibm-acpi doesn't issue hardware calls that would not change the
brightness value.

If a brightness value query is causing blinks on your thinkpad, something is
very weird.

Maybe something else is also getting these events and processing them?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
