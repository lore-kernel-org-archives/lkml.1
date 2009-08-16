Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbZHPO2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbZHPO2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 10:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZHPO2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 10:28:36 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:34411 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbZHPO2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 10:28:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lbzEArodSkfOkEKznR5GA+DJT3bdm4qYkADGgDcpmemS2IBYqUs4/RGTxx0Mq64S0u
         kI9C3tygKpXhhRPUr8/mEZfu30j/xKsFT3rDB9KW+LCMmkUQPczzibJiKwLcdqT6+EI9
         qPCaPPpDR7qk9T2rbS/rC0bEBMiqQUtQsBKlw=
Subject: Re: [BUG] [hwmon] linux 2.6.31-rc6 regression
From: Calvin Walton <calvin.walton@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Zeev Tarantov <zeev.tarantov@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090816053735.GB1998@phenom2.trippelsdorf.de>
References: <12d7e64c0908150329k1bf123der18e74112c5b9cd97@mail.gmail.com>
	 <20090816010303.GA9588@srcf.ucam.org>
	 <20090816053735.GB1998@phenom2.trippelsdorf.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Aug 2009 10:28:13 -0400
Message-Id: <1250432893.7591.5.camel@ayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-16 at 07:37 +0200, Markus Trippelsdorf wrote:
> On Sun, Aug 16, 2009 at 02:03:03AM +0100, Matthew Garrett wrote:
> > On Sat, Aug 15, 2009 at 01:29:48PM +0300, Zeev Tarantov wrote:
> > 
> > > [    3.276720] w83627ehf: Found W83627DHG chip at 0x290
> > > [    3.276894] ACPI: I/O resource w83627ehf [0x295-0x296] conflicts
> > > with ACPI region HWRE [0x290-0x299]
> > > [    3.277171] ACPI: Device needs an ACPI driver
> > 
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

Note that, as this is an ASUS board, there is actually an ACPI firmware
driver available that will let you do hardware monitoring in a way that
doesn't conflict with the firmware - give the "ASUS ATK0110 ACPI hwmon"
driver a try.

-- 
Calvin Walton <calvin.walton@gmail.com>

