Return-Path: <linux-kernel-owner+w=401wt.eu-S1751283AbXBZPhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbXBZPhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 10:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbXBZPhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 10:37:05 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:53638 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbXBZPhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 10:37:03 -0500
X-Sasl-enc: GT/I1Y9qAqjOK8eFYwbEEch7+QQmsLGdwmW7rZDHFc1O 1172503260
Date: Mon, 26 Feb 2007 12:20:35 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc1 dims my LCD
Message-ID: <20070226152035.GB2909@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz> <1172490091.5824.30.camel@localhost.localdomain> <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz> <20070226142157.GA2909@khazad-dum.debian.net> <1172501357.5824.91.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172501357.5824.91.camel@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007, Richard Purdie wrote:
> > Richard, would you like a patch to -ENOSYS if a display power management
> > event reaches ibm-acpi?
> 
> The ibm backlight driver should really try and work with the system a
> little more. Even if it can't turn the display off, the power attribute
> should  minimise power usage as best it can. If that means just dimming
> the display, so be it. Ideally, I'd still prefer for it to gain support
> for turning the display off.

Well, the thinkpad firmware doesn't know how to turn the backlight off, or
doesn't export that AFAIK.  It *can* do it in hardware (cuts power to the
inverter or somesuch in the lid switch, etc) but I know of no way to do it
using the firmware.  If I ever find a way, I will certainly add it.

The video card *can* do it, but we are talking either intel fb or radeon fb
here, I'd need a way to communicate with them, or they should be getting the
same events and doing it anyway.

> In the update_status function, there are three sources of information
> you need to combine:
> 
> bd->props.brightness
> bd->props.power
> bd->props.fb_blank
> 
> Since the backlight class doesn't know the capabilities of the hardware,
> it is left to each implementation to combine these options in a way that
> makes sense. Currently ibm just looks at the first one but it could dim
> if the latter two are anything other than FB_BLANK_UNBLANK. See corgi_bl
> as an example (which also looks at its own variables too).

I will implement that, and as usual I will request your ACK since it deals
with your subsystem too.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
