Return-Path: <linux-kernel-owner+w=401wt.eu-S1752364Ab0A2GYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab0A2GYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 01:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300Ab0A2GYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 01:24:12 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:56206 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab0A2GYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 01:24:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u+ZhHRHnCryLVOqIHWBU1sT7dSDGz4B9tbNvKCI78qNflenZGQEUaKaAM/hgo9a0RL
         CzUrkNbgj4QJUh5U271gMAaT/9SfgPTqRWcRCKOV3+dCX0BLhSvjhsmAuX9pHABkHNlu
         25eqzCvIxPTfqb9a2xGVaEWsB/p3KOq0DUWM0=
Date: Thu, 28 Jan 2010 22:24:05 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PNP PS/2 probing racy?
Message-ID: <20100129062405.GA4177@core.coreip.homeip.net>
References: <20100128135405.GA28931@basil.fritz.box>
 <DE24773B-F00A-4866-8E88-AE63E6135743@gmail.com>
 <20100128162248.GF14636@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100128162248.GF14636@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 05:22:48PM +0100, Andi Kleen wrote:
> On Thu, Jan 28, 2010 at 07:57:47AM -0800, Dmitry Torokhov wrote:
> >> Hi,
> >>
> >> I noticed that on one test system of machine when booting the same
> >> kernel I get:
> >>
> >> PNP: No PS/2 controller found. Probing ports directly.
> >> serio: i8042 KBD port at 0x60,0x64 irq 1
> >> serio: i8042 AUX port at 0x60,0x64 irq 12
> >>
> >> and sometimes on another boot
> >>
> >> PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
> >>
> >> Since I presume the BIOS does not change, is it possible the Linux
> >> procedure for this PNP probe is racy? I haven't checked the code so far.
> >>
> >
> > Are you using KVM with that box by any chance?
> 
> Yes, it uses a KVM, but the console was always on it.
> 

That is wierd... Was it on the whole time (including the time when BIOS
was doing the initialization)? Anyway i8042 expects to find all PNP
devices already enumerated by the time its initialization runs. When
you see that message about PS2 controller not found do you see PNP0303
and PNP0f03 if you do:

	for i in /sys/devices/pnp0/00*; do echo -n "$i: "; cat $i/id; done

?

-- 
Dmitry
