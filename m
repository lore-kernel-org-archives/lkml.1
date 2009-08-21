Return-Path: <linux-kernel-owner+w=401wt.eu-S932774AbZHUXTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774AbZHUXTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 19:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932548AbZHUXTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 19:19:54 -0400
Received: from outbound-mail-113.bluehost.com ([69.89.24.3]:48385 "HELO
	outbound-mail-113.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932533AbZHUXTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 19:19:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Hy54+4hVa01EOCoOEjHs5WgtehEzc9iw+TI5DlVF5quZD+8jXMaEEreYnjltVOi03o1XyR0lA2QJpNZmT0Ed0s7MunfNdXnTkfSrDc0md4GzvSzgovHvgYgVcs1BMBWs;
Date: Fri, 21 Aug 2009 16:19:52 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Soeren Sonnenburg <bugreports@nn7.de>,
       =?UTF-8?B?SsOpcsOpbWll?= Huchet <jeremie@lamah.info>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Samsung laptop driver
Message-ID: <20090821161952.1b84480c@jbarnes-g45>
In-Reply-To: <20090821225925.GA27625@kroah.com>
References: <20090821225925.GA27625@kroah.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009 15:59:25 -0700
Greg KH <greg@kroah.com> wrote:
> Jesse, I don't know how this is going to play with your recently added
> backlight support for the i915 driver.  As you don't have control over
> the LEDs and other stuff that this driver is going to support, I think
> we need some way to keep the i915 driver from messing with the
> backlight values, don't you think?

Right, it should be fine.  The i915 driver should only take control and
provide a backlight when:
  - no ACPI method is available
  - no platform method is available (like this one)
  - backlight is exposed through the GPU or i2c

So I'm a lot happier now that you've figured out the proper platform
interface. :)  The test code I sent out earlier didn't work for Mike
because his VBIOS (properly it turns out) indicated that there was an
external agent in charge of the backlight.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
