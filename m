Return-Path: <linux-kernel-owner+w=401wt.eu-S1752446AbYIJNhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbYIJNhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 09:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbYIJNhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 09:37:22 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:43892 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbYIJNhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 09:37:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EegT4vfkDvv588bnd3jx2/foMT1nAwifb98xFhPm9lmBJDXD2Q7g+qI+DvV8DLJt2/
         +YuFXq5JaSQ4u5ItDby0lBfPcjYIa2lCLSrk3QU8NQ/Ag8x6L20ICSkGylbztyiOKFSs
         DZE12D40k2d+VfHzF+9Argf/42vG9ble1Rl/A=
Message-ID: <9e4733910809100637t55cdf1c0r19372bb74d3be57d@mail.gmail.com>
Date: Wed, 10 Sep 2008 09:37:19 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH 06/18] lirc driver for the ATI USB RF remote receiver
Cc: "Jarod Wilson" <jwilson@redhat.com>, "Ville Syrj?l?" <syrjala@sci.fi>,
       "Janne Grunau" <j@jannau.net>, linux-kernel@vger.kernel.org,
       "Christoph Bartelmus" <lirc@bartelmus.de>,
       lirc-list@lists.sourceforge.net
In-Reply-To: <20080910131432.GA2161@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
	 <1220933164-10160-7-git-send-email-jwilson@redhat.com>
	 <20080910095832.GA22422@sci.fi>
	 <200809100905.58304.jwilson@redhat.com>
	 <20080910131432.GA2161@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/10/08, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Sep 10, 2008 at 09:05:58AM -0400, Jarod Wilson wrote:
>  > True, though I think some users still prefer using them with the lirc drivers
>  > for assorted reasons. Configuring something like mythtv to work with the
>  > ati_remote{,2} driver appears to be a bit more complex (or at least non-
>  > standard vs. several other popular remotes) and not as functional vs.
>  > configuring mythtv w/lirc_atiusb.
>
>
> Bad idea to have two drivers for the same piece of hardware.  And this
>  gets straight back into the why should lirc be different from the input
>  layer point raised earlies.  I think we really shouldn't keep lirc as
>  a separate subsystem, but make sure all the drivers are written to the
>  input layer.  To make the migration easier for exiting users we could
>  add a /dev/lirc driver ontop of the input layer, similar to how the ps2
>  mouse and joystick drivers sit ontop of the input core.

There have been concerns on the lirc list that integrating with the
input core would mean that the kernel has to translate from the lirc
timing data to key strokes. Keyboards do their translation in user
space, lirc can do the same, right? User space app receives lirc event
and then calls a translation library function.

A second issue is that some IR drivers are completely in user space.
Is there a mechanism for these user space drivers to send events down
into the input layer? These events would then get queued with the
other kernel generated events and be delivered to consuming apps in
order.


>
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Jon Smirl
jonsmirl@gmail.com
