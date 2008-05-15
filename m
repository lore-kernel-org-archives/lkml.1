Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbYEODNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbYEODNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 23:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYEODMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 23:12:55 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:53392 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbYEODMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 23:12:55 -0400
Date: Wed, 14 May 2008 20:12:53 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Greg KH <greg@kroah.com>
cc: Markus Rechberger <mrechberger@gmail.com>, video4linux-list@redhat.com,
       linux-usb@vger.kernel.org, dean@sensoray.com,
       linux-kernel@vger.kernel.org, mchehab@infradead.org,
       v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] USB: add Sensoray 2255 v4l driver
In-Reply-To: <20080515024141.GB21941@kroah.com>
Message-ID: <Pine.LNX.4.58.0805142006130.23876@shell4.speakeasy.net>
References: <20080514205927.GA13134@kroah.com>
 <d9def9db0805141817n4182deedp780791b0a51fb7be@mail.gmail.com>
 <20080515024141.GB21941@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Greg KH wrote:
> On Thu, May 15, 2008 at 03:17:42AM +0200, Markus Rechberger wrote:
> > Hi Dean, Greg,
>
> Adding dean to the cc: line...  :)
> >
> > On 5/14/08, Greg KH <greg@kroah.com> wrote:
> > > From: Dean Anderson <dean@sensoray.com>
> > >
>
> <big patch snipped>
>
> > Why do you do those conversions in kernelspace?
> > ffmpeg/libswscale has optimized code for colourspace conversions.
> > I know a few drivers do that in kernelspace but it's way more flexible
> > in userspace and depending on the optimization requires less CPU
> > power.
>
> I thought they were there as needed by some V4L1 applications, but that
> code was recently removed by Dean I think.  If they don't need to be
> there, and userspace apps can properly handle the different colorspace,
> then I'll be glad to remove them.

Virtually all apps (V4L1 & 2) can handle YUV and RGB colorspaces.
Certainly all the major ones do and all the major libraries as well.

The problem is when the device only supports some vendor specific or
otherwise very uncommon format.  In that case not doing the conversion in
the kernel means the device won't work with any existing software without
patches.  In this case, while it's not "the right way", drivers often end
up including an in kernel conversion for pragmatic reasons.

This was a problem with the bayer format, but now userspace support for
that format is more common.
