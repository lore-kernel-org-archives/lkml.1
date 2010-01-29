Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549Ab0A2MY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab0A2MY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 07:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126Ab0A2MYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 07:24:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51203 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab0A2MYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 07:24:24 -0500
Date: Fri, 29 Jan 2010 13:24:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PNP PS/2 probing racy?
Message-ID: <20100129122422.GD29555@one.firstfloor.org>
References: <20100128135405.GA28931@basil.fritz.box> <DE24773B-F00A-4866-8E88-AE63E6135743@gmail.com> <20100128162248.GF14636@basil.fritz.box> <20100129062405.GA4177@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129062405.GA4177@core.coreip.homeip.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 10:24:05PM -0800, Dmitry Torokhov wrote:
> On Thu, Jan 28, 2010 at 05:22:48PM +0100, Andi Kleen wrote:
> > On Thu, Jan 28, 2010 at 07:57:47AM -0800, Dmitry Torokhov wrote:
> > >> Hi,
> > >>
> > >> I noticed that on one test system of machine when booting the same
> > >> kernel I get:
> > >>
> > >> PNP: No PS/2 controller found. Probing ports directly.
> > >> serio: i8042 KBD port at 0x60,0x64 irq 1
> > >> serio: i8042 AUX port at 0x60,0x64 irq 12
> > >>
> > >> and sometimes on another boot
> > >>
> > >> PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
> > >>
> > >> Since I presume the BIOS does not change, is it possible the Linux
> > >> procedure for this PNP probe is racy? I haven't checked the code so far.
> > >>
> > >
> > > Are you using KVM with that box by any chance?
> > 
> > Yes, it uses a KVM, but the console was always on it.
> > 
> 
> That is wierd... Was it on the whole time (including the time when BIOS
> was doing the initialization)? Anyway i8042 expects to find all PNP

I think so. That is of course the KVM might have a special state
when the display is off, but it's hard for me to detect that.
But I didn't switch the display

> devices already enumerated by the time its initialization runs. When
> you see that message about PS2 controller not found do you see PNP0303
> and PNP0f03 if you do:
> 
> 	for i in /sys/devices/pnp0/00*; do echo -n "$i: "; cat $i/id; done

I'll check next time (machine out of reach right now)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
