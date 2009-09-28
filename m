Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbZI1RDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbZI1RDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 13:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZI1RDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 13:03:12 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:59075 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbZI1RDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 13:03:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xFsshp7MmLFaEC7SrSKbxDkvnT/cGGaSusLle+HNv4cnCxP4iUvtxbcfzo32AfxcxL
         XeEWsRspsb82wHhtZ/gsE6BtfWcM+HNHs3yMs+VuXcMSm+Vi/V4FNe4b5kmrNDBGap2r
         i/ecureWw3iOEdfwWQIu1eYAFSAe/q5lX28VQ=
Date: Mon, 28 Sep 2009 10:03:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Trilok Soni <soni.trilok@gmail.com>,
       Linux USB <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: Using EV_MSC or extending KEY_*
Message-ID: <20090928170308.GH21455@core.coreip.homeip.net>
References: <aac07123ee2b14a0ac25d1652dbe0780.squirrel@intranet.cs.nmsu.edu> <5d5443650909151011k4b21a6d0n28ac6142c3d7161d@mail.gmail.com> <20090915183406.GA5696@core.coreip.homeip.net> <0debc76f26fe85e28adf642396233928.squirrel@intranet.cs.nmsu.edu> <20090916034642.GC2756@core.coreip.homeip.net> <2c0ac825ebe78da99328b896faae04a2.squirrel@intranet.cs.nmsu.edu> <20090917175707.GB789@khazad-dum.debian.net> <20090918064627.GG18668@core.coreip.homeip.net> <4d6ae6e7ee9b38f99e38d357dc755d64.squirrel@intranet.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d6ae6e7ee9b38f99e38d357dc755d64.squirrel@intranet.cs.nmsu.edu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 09:40:23AM -0600, Rick L. Vinyard, Jr. wrote:
> Dmitry Torokhov wrote:
> > On Thu, Sep 17, 2009 at 02:57:07PM -0300, Henrique de Moraes Holschuh
> > wrote:
> >> On Wed, 16 Sep 2009, Rick L. Vinyard, Jr. wrote:
> >> > The M* keys are intended to provide a quick way to switch between key
> >> > mappings, with each mode having their own user-defined mappings.
> >>
> >> What I'd do in this case would be this:
> >>
> >> 1. Initially have the M* level-shift keys assigned KEY_RESERVED
> >>
> >> 2. Have a big enough keymap to map all keys in all M*-level shift states
> >> possible.
> >>
> >> Eg:
> >>    START OF KEYMAP
> >>    M* keys
> >>    1st set of G* keys
> >>    2nd set of G* keys
> >>    3rd set of G* keys...
> >>    ...
> >>    last set of G* keys
> >>    END OF KEYMAP
> >>
> >> 3. Have the driver special-process M* level-shift keys *as long as they
> >> are
> >> still set to KEY_RESERVED* to select which part of the keymap is used to
> >> translate the other keys.  Note that this likely means pressing a M* key
> >> would be transparent to userspace in this case, i.e. no events would be
> >> issued when a M* key is doing a level shift.
> >>
> >> So, you'd be able to set all mappings you want in the driver, and the M*
> >> keys would do what they're expected to do without any userland help at
> >> all,
> >> but you'd still be able to program the M* keys to be normal keys if you
> >> want.
> >>
> >> Of course, this assumes you don't do chording on multiple M* keys to end
> >> up
> >> with a huge number of keymaps :p
> >>
> >
> > Actually I think that the device should just emit KEY_PROG1..KEY_PROG4
> > for the M keys and have userspace daemon load alternate keymaps on the
> > fly in resaponse to KEY_PROGx. The device is just a set of completely
> > generic buttons... User will have to tell the kernel what to map them
> > to.
> >
> 
> Emitting a keycode certainly does simplify things, but that will preclude
> the user from programming the G-keys to KEY_PROG1..KEY_PROG4.
> 
> Are there any specific use cases where a user would want to program a
> G-key to KEY_PROG1..KEY_PROG4?
> 

I an not sure, but if they want to use KEY_PROG* somewhere else they can
reprogram the M* keys to somethis other as well.

-- 
Dmitry
