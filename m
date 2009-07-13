Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbZGMDmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbZGMDmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 23:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZGMDmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 23:42:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:58092 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbZGMDmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 23:42:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Lf7Xoub3i0J3Fv4GjdhChPlT2uTCsdksgnBYexq+8kLgvzRcYzDaKDWVfuKXJa78/9
         oU/Q08uPITo0NI4H+iYJZ5Kyl4FUOUFCvpsc3ievD1qGE1uXU1J+xeVsg67mP2QTohCx
         BvSXh/V4bmsF2EFxhL4Ath8MkCN9qy6uGf1kQ=
Date: Sun, 12 Jul 2009 20:41:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Mark Lord <lkml@rtr.ca>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: Input driver for Twinhan USB 6253:0100 remote control
Message-ID: <20090713034159.GA10819@dtor-d630.eng.vmware.com>
References: <20090408072935.GA27920@dtor-d630.eng.vmware.com> <200904131931.24009.dmitry.torokhov@gmail.com> <49E4B678.9030508@rtr.ca> <200904140945.14652.dmitry.torokhov@gmail.com> <49E4C9CF.5060504@rtr.ca> <alpine.LNX.2.00.0904151022170.13028@wotan.suse.de> <49E5EAD7.7000309@rtr.ca> <alpine.LNX.2.00.0904161123180.13028@wotan.suse.de> <20090712182026.7a09c736@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090712182026.7a09c736@neptune.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 06:20:26PM +0200, Bruno Prémont wrote:
> On Thu, 16 April 2009 Jiri Kosina <jkosina@suse.cz> wrote:
> > On Wed, 15 Apr 2009, Mark Lord wrote:
> > > > Yes, hid-belking is a good example of trivial driver that sits on
> > > > a HID bus for you, as it utilizes the ->input_mapping() callback,
> > > > which is probably the only callback from HID core you'd need.
> > > Actually, the input-mapping() alone won't do the job here.
> > > This Twinhan remote control sends single-byte codes for most
> > > buttons, but some buttons send multi-byte codes, and we have to
> > > discard the extraneous bytes somehow.
> > 
> > If the usages make it through the generic HID layer (depends on the
> > report descriptor of the device), then just registering hid_driver
> > with ->event() set to your callback and fixing this on the fly could
> > be enough.
> 
> I do have such a remote around.
> 
> I wrote the below patch to adjust it's key mappings, though I'm not
> sure if/how I should deal with the number keys (0..9) with regard to
> keyboard layout and/or numlock key.
> 
> I tried with KEY_0..KEY_9 (default) as well as KEY_KP0..KEY_KP9 but
> neither produces optimal results on my machine (laptop with numlock
> disabled and belgian keyboard layout, e.g. KEY_1 => '&' unless shift
> is down)
> i

That was the reason KEY_NUMERIC_* keycodes were intriduced - they
shuppsed to be unaffected by labuguage keymap or numlock state.

> KEY_NUMERIC_0..KEY_NUMERIC_9 are not recognized by Linux console (don't
> know if/how userspace understands them)
> 

They just probably missing from the installed keymap, that's all.

-- 
Dmitry
