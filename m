Return-Path: <linux-kernel-owner+w=401wt.eu-S1751763AbYIBNAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbYIBNAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 09:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYIBNAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 09:00:32 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:23907 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYIBNAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 09:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EhtqeygcgmooF4lYaziBbhllA1EcZwOcIUKqReycG6tK5qF2KI6FgmzJ+RPH7LhyAQ
         gUFNGDppwWkyvYSvVjx//4dDqL5CYPOVTn84vtflBggGCu97fbqbQxQRuraDN7GkBLdS
         rCdYDcHomxwAo8a94OOKm87VNstpDs9/Fepbw=
Date: Tue, 2 Sep 2008 09:00:26 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: akpm@osdl.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] input: bcm5974-0.61: New default mouse driver mode
Message-ID: <20080902085209.ZZRA012@mailhub.coreip.homeip.net>
References: <48BC4BC3.1080903@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BC4BC3.1080903@euromail.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Mon, Sep 01, 2008 at 10:08:35PM +0200, Henrik Rydberg wrote:
> Currently, the Apple bcm5974 driver only mimics a synaptics touchpad, not a mouse.
> This creates unnecessary complications on systems where the synaptics driver is absent
> or not configured, such as in a completely new system, or a text console.

Mousedev should provide a reasonable emulation of standard mouse
giving user chance to configure the system properly. There is no need
to task the driver to provide such emulation and therefore I will not
apply this patch.

> This patch
> provides a default compatibility configuration, which works as a multi-button mouse,
> implemented using rudimentary multi-finger options. It yields the following benefits:
> 
> * A default Xorg configuration will pick up the mouse input interface, resulting in a
> functional mouse pointer out-of-the-box on many systems.

This happens automatically with Synaptics hardware on newer
distributions (at least Fedora 9 does this). As far as I know
SYnaptics driver does no look for specific product but for a certain
features of the input device and so shoudl work for BCM as well.

> 
> * Two-finger scroll emulates a mouse wheel.
> 
> * Three-finger swipe emulates a horizontal mouse wheel.
> 
> * Multi-finger clicks emulate the middle and right mouse buttons.
>

The kenel driver should only do as little translation as possible,
allowing userspace to decide how to implement more fancy features.

> * The mouse driver also works with gpm in text consoles, providing cut-and-paste functionality.
>

Does not mousedev emulation work from GPM? Also GPM has evdev protocol
support which should work very well with synaptics-like touchpads.

-- 
Dmitry
