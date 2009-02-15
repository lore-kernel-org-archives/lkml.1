Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZBOAQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZBOAQc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 19:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZBOAQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 19:16:24 -0500
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:39297 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536AbZBOAQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 19:16:23 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqgEABftlknZiM0E/2dsb2JhbACBbM81hBwG
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [build bug] uvc_status_cleanup(): undefined reference to `input_unregister_device'
Date: Sun, 15 Feb 2009 01:19:48 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.28; KDE/4.2.0; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20090208145835.GA1649@elte.hu> <200902111247.39922.laurent.pinchart@skynet.be> <20090211105600.32eefe7b@pedra.chehab.org>
In-Reply-To: <20090211105600.32eefe7b@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902150119.48355.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Wednesday 11 February 2009 13:56:00 Mauro Carvalho Chehab wrote:
> On Wed, 11 Feb 2009 12:47:39 +0100
>
> Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> > Hi Mauro,
> >
> > On Wednesday 11 February 2009 09:29:33 Mauro Carvalho Chehab wrote:
[snip]
> > That's even worse. The following configurations would then be valid
> >
> > INPUT = m/y
> > USB_VIDEO_CLASS = n
> > USB_VIDEO_CLASS_INPUT_EVDEV = m/y
> >
> > USB_VIDEO_CLASS_INPUT_EVDEV must depend on USB_VIDEO_CLASS to be
> > displayed as a child of USB_VIDEO_CLASS in the configuration menu.
>
> USB_VIDEO_CLASS_INPUT_EVDEV can't be m, since it is bool.

Oops, sorry, my bad.

> But, you're right: we'll loose the dependency of USB_VIDEO_CLASS_INPUT_EVDEV 
> and USB_VIDEO_CLASS.
>
> There's another alternative, if we consider that all systems but a few
> embedded ones have input defined.
>
> We may do something like:
>
> diff --git a/drivers/media/video/uvc/Kconfig
> b/drivers/media/video/uvc/Kconfig index c2d9760..14e7537 100644 ---
> a/drivers/media/video/uvc/Kconfig
> +++ b/drivers/media/video/uvc/Kconfig
> @@ -1,5 +1,6 @@
>  config USB_VIDEO_CLASS
>  	tristate "USB Video Class (UVC)"
> +	depends on INPUT
>  	---help---
>  	  Support for the USB Video Class (UVC).  Currently only video
>  	  input devices, such as webcams, are supported.
>
> I suspect that this will work fine for all practical usages.

Then we could as well remove the USB_VIDEO_CLASS_INPUT_EVDEV option. Its sole 
purpose was to remove the hard dependency of USB_VIDEO_CLASS on INPUT.

> Another option would be to have a generic option at V4L for evdev
> interfaces (config MEDIA_EVDEV), that is independent of uvc (the same kind
> of dependency exists on other drivers at the subsystem, like cx88, saa7134,
> etc). It will be a larger changeset, but maybe useful, since someone may
> disable EVDEV interface for other V4L/DVB drivers as well.

What I need here is a way to express the following in Kconfig:

- USB_VIDEO_CLASS_INPUT_EVDEV is a boolean sub-option of USB_VIDEO_CLASS
- It can only be selected if the USB_VIDEO_CLASS and INPUT options "match"
- Ideally, the options should always be visible (otherwise people would only 
notice the option if INPUT support is enabled), but should not be selectable 
if USB_VIDEO_CLASS and INPUT don't match.

Is this possible ?

Best regards,

Laurent Pinchart

