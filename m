Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbZIOSeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbZIOSeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbZIOSeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:34:13 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:39047 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbZIOSeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:34:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VrBh7N3B1JiamStPccNq/xqpVJxkZTwEQg+TXSMA5/QCMNA81uEgNyR7CAQ+PMCz7b
         qW8cYTF4iCKK1C9mEG0RYiAuYV1x3erx9DaOex862UNcPINmPvKJsexT+tq9NRJb6BIB
         PHyksaVg9QqlVz4EUAh1Lf6G2drl+J6odE6wc=
Date: Tue, 15 Sep 2009 11:34:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>,
       Linux USB <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: Using EV_MSC or extending KEY_*
Message-ID: <20090915183406.GA5696@core.coreip.homeip.net>
References: <aac07123ee2b14a0ac25d1652dbe0780.squirrel@intranet.cs.nmsu.edu> <5d5443650909151011k4b21a6d0n28ac6142c3d7161d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5443650909151011k4b21a6d0n28ac6142c3d7161d@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 10:41:30PM +0530, Trilok Soni wrote:
> Adding linux-input.
> 
> On Tue, Sep 15, 2009 at 9:49 PM, Rick L. Vinyard, Jr.
> <rvinyard@cs.nmsu.edu> wrote:
> > On the Logitech G13 there are a set of 10 special keys at the top of the
> > device.
> >
> > I've written the driver so that it maintains a map from the general keys
> > (G1-G22) to Linux' input subsystem keys.
> >
> > The map can be changed on the fly, allowing multiple keymaps to be loaded.
> >
> > As a side note I haven't provided for this functionality (multiple
> > keymaps) in the driver since this can be maintained from userspace, but it
> > does need to know about the currently loaded keymap so that when the raw
> > HID events are parsed the appropriate EV_KEY events can be input.
> >
> > I could set it up so that the special keys also map to a KEY_* code.
> > However, I'd prefer to set things up so that any G1-G22 key can be mapped
> > to any input subsystem KEY_* code and not reserve a set of 10 from the
> > current KEY_* codes for the 10 special keys.
> >
> > One way I was thinking of approaching this was to generate EV_MSC type
> > events (with a MSC_RAW code) using the value to indicate the state
> > (pressed/released) and special key.

Doesn't HID already generate EV_MSC/MSC_SCAN for exactly this purpose
so userspace knows what keys can be remapped? You may initially map all
keys you don't know the usage to KEY_UNKNOWN.

> >
> > Another way to approach this would be to extend the KEY_* #defines with a
> > special set of 10 codes for the 10 special keys.
> >

No, please don't do this.

-- 
Dmitry
