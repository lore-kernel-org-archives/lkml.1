Return-Path: <linux-kernel-owner+w=401wt.eu-S1751038AbZIPDqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038AbZIPDqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 23:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbZIPDqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 23:46:49 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:60289 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbZIPDqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 23:46:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D0RHpQBm4A7mkmCxBriLN/IwdTf27KhqoF/9SnubjKvKdcQjGgbVSh2+xgyfN4Maww
         vRh/EULCeUWbGkvM6azKLXZzu9PQ6tyGU5K+6Jwr5XDWT56uFEBLr2cnkKsPMzKIrcCN
         zKPScc8cIGPXQOR4eQFPFADPxUHUjrry29hfE=
Date: Tue, 15 Sep 2009 20:46:42 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Trilok Soni <soni.trilok@gmail.com>, Linux USB <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: Using EV_MSC or extending KEY_*
Message-ID: <20090916034642.GC2756@core.coreip.homeip.net>
References: <aac07123ee2b14a0ac25d1652dbe0780.squirrel@intranet.cs.nmsu.edu> <5d5443650909151011k4b21a6d0n28ac6142c3d7161d@mail.gmail.com> <20090915183406.GA5696@core.coreip.homeip.net> <0debc76f26fe85e28adf642396233928.squirrel@intranet.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0debc76f26fe85e28adf642396233928.squirrel@intranet.cs.nmsu.edu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 01:05:57PM -0600, Rick L. Vinyard, Jr. wrote:
> Dmitry Torokhov wrote:
> > On Tue, Sep 15, 2009 at 10:41:30PM +0530, Trilok Soni wrote:
> >> Adding linux-input.
> >>
> >> On Tue, Sep 15, 2009 at 9:49 PM, Rick L. Vinyard, Jr.
> >> <rvinyard@cs.nmsu.edu> wrote:
> >> > On the Logitech G13 there are a set of 10 special keys at the top of
> >> the
> >> > device.
> >> >
> >> > I've written the driver so that it maintains a map from the general
> >> keys
> >> > (G1-G22) to Linux' input subsystem keys.
> >> >
> >> > The map can be changed on the fly, allowing multiple keymaps to be
> >> loaded.
> >> >
> >> > As a side note I haven't provided for this functionality (multiple
> >> > keymaps) in the driver since this can be maintained from userspace,
> >> but it
> >> > does need to know about the currently loaded keymap so that when the
> >> raw
> >> > HID events are parsed the appropriate EV_KEY events can be input.
> >> >
> >> > I could set it up so that the special keys also map to a KEY_* code.
> >> > However, I'd prefer to set things up so that any G1-G22 key can be
> >> mapped
> >> > to any input subsystem KEY_* code and not reserve a set of 10 from the
> >> > current KEY_* codes for the 10 special keys.
> >> >
> >> > One way I was thinking of approaching this was to generate EV_MSC type
> >> > events (with a MSC_RAW code) using the value to indicate the state
> >> > (pressed/released) and special key.
> >
> > Doesn't HID already generate EV_MSC/MSC_SCAN for exactly this purpose
> > so userspace knows what keys can be remapped? You may initially map all
> > keys you don't know the usage to KEY_UNKNOWN.
> 
> As I understand it the EV_MSC/MSC_SCAN is used to trigger a prompting of
> the user to map a key, which would be useful for the G1-G22 keys and
> perhaps 5 of the 10 special keys. But, that's not the behavior I want for
> the M1, M2, M3, MR and backlight keys.
> 
> Somehow they need to be distinct from any existing KEY_* codes or not have
> a code at all... i.e. only emitting the raw misc events.
> 
> Perhaps the BTN_MISC codes are better suited for these keys?
> 

I am sorry, I don't follow... why would yo not want to assign a standard
code to the M* keys?

-- 
Dmitry
