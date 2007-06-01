Return-Path: <linux-kernel-owner+w=401wt.eu-S1761456AbXFAOTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456AbXFAOTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 10:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761071AbXFAOTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 10:19:13 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:41663 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760963AbXFAOTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 10:19:11 -0400
Date: Fri, 1 Jun 2007 15:19:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Richard Hughes <hughsient@gmail.com>, linux-acpi@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Message-ID: <20070601141901.GA13939@srcf.ucam.org>
References: <11802004861625-git-send-email-hmh@hmh.eng.br> <200705312333.11477.dtor@insightbb.com> <20070601040824.GA5042@srcf.ucam.org> <200706010037.59496.dtor@insightbb.com> <20070601131324.GB12204@srcf.ucam.org> <d120d5000706010704h71c817a9p55e0bba5d54efd3f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000706010704h71c817a9p55e0bba5d54efd3f@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Input: document the proper usage of EV_KEY and KEY_UNKNOWN
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 10:04:56AM -0400, Dmitry Torokhov wrote:

> Anyway, I think that we don't want ordinary users to alter hardware
> keymapping, it should indeed be priveleged operation done by box's
> administrator. Hopefully the infrastructure (hal/udev/whatever) will
> be able to load proper keymap at boot time so even that is not needed.

Any solution which involves a naive user pressing a key and a dialog 
appearing saying "Please enter the administrator password to map this 
key" is not a satisfactory solution. 

> - X remapping only works in X. Even if you say that major
> distributions presently moved all logic in X but I don't think it is
> the only true way (in fact I think that some of it should run as
> standalone daemons; if I press power button I want my box to shut down
> even if I happen to be at text console. Same goes for sleep).

That's simply not a use-case we (or, as far as I can tell, any of the 
other major distributions) are interested in. It's very difficult to 
come up with a method for providing per-user policy without it depending 
on X.

> - KEY_PROG* are assigned somewhat randomly across devices, with
> KEY_PROG1 matching FN-F1 on laptop multimedia key and also on one of
> the buttons on that remote control that manufacturers tend to supply
> with those "desktop replacement" laptops. Remapping them in X will not
> satisfy user. However remappig into actions (like KEY_EJECTCD) on
> kernel level solves this. From user perspective there isn't really any
> difference - he assigns an action to a key.

Producing KEY_PROG* by default doesn't prevent this in any way. With the 
exception of the PS/2 keyboard nightmare, we're always able to 
distinguish between different input devices and remap them if necessary. 
It's fine to require extra complexity for more complicated cases. That 
doesn't mean it's worth requiring that complexity for all cases.

> - If using X remapping alone every user will have to repeat the task
> of mapping keycodes. In case when there are labels on the keyboard
> (but the kernel does not know what it is) that setup is likely to be
> identical for most users on the box. I venture to say that even with
> unlabeled keys the setup will be identical - first user will influence
> the rest.

That problem is already solved at the desktop level.

> The biggest cons for KEY_UNKNOWN + scancode is that presently we do
> not have the code to iteract with user.

It's a large pile of code and it's going to have to be implemented 
multiple times in order to integrate with the different desktop 
environments. I really don't think it's worth it.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
