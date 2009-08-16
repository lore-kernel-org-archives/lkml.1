Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbZHPNiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbZHPNiS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 09:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbZHPNiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 09:38:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47088 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750914AbZHPNiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 09:38:17 -0400
Date: Sun, 16 Aug 2009 14:38:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Zeev Tarantov <zeev.tarantov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] [hwmon] linux 2.6.31-rc6 regression
Message-ID: <20090816143846.5c729d95@lxorguk.ukuu.org.uk>
In-Reply-To: <20090816053735.GB1998@phenom2.trippelsdorf.de>
References: <12d7e64c0908150329k1bf123der18e74112c5b9cd97@mail.gmail.com>
	<20090816010303.GA9588@srcf.ucam.org>
	<20090816053735.GB1998@phenom2.trippelsdorf.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The hwmon driver is attempting to allocate a region that's also used by 
> > your ACPI firmware. There's no way to synchronise access between the 
> > kernel and the firmware, so allowing both is potentially racy - we've 
> > seen numerous cases where the combination results in the system 
> > incorrectly generating critical temperatuer shutdowns, for instance, 
> > when some other indexed access gets interpreted as the temperature or 
> > when the hwmon chip's state machine is confused. The failure of hwmon to 
> > bind is a feature here, not a bug. You can override it with 
> > acpi_enforce_resources=no on the kernel command line.
> 
> But we don't introduce »features« that break hardware monitoring on
> numerous machines in rc6 normally, IIRC.
> If this so important and critical to you, than just add a »hyperstrict«
> parameter to acpi_enforce_resources or make »lax« the default.

This is a bug fix not a feature - clashing hwmon and ACPI can seriously
screw up a system, cause it to do things like shutdown randomly and the
like.

Alan
