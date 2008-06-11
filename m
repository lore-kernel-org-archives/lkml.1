Return-Path: <linux-kernel-owner+w=401wt.eu-S1758986AbYFKUaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbYFKUaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:30:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756432AbYFKU1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:27:13 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:20186 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753084AbYFKU1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:27:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oyR3mZvnYJKWfd3Pu3IeR7VeSd9+Zas8Zpl+KZxbEmagDVHu+rWSUM9B7/xG14RuRyIQbACBfophZ2LsObbQ5YniaNTMFQGeriW4IHRIJoipAKGpMfPlZ9g7tvbHVrRIC98if21ZtzQnrF2Baa/oeEpgg3HBTjE7ciCm+yTZA8c=  ;
X-YMail-OSG: DuoF2BEVM1kpnCkb5OiAcCgmdczJi1e24fhQuSbPTca8_YwSP.I.TjzqNI152xxMOvgDZJvv8i0hEEVDZ4NoOXvtpaTA9TTMvugTx94cU52TDuuBXMiHxBjufueFGOD3lvI-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH, RFC] Earlier I2C initialization
Date: Wed, 11 Jun 2008 13:27:09 -0700
User-Agent: KMail/1.9.9
Cc: Ryan Mallon <ryan@bluewatersys.com>, Uli Luckas <u.luckas@road.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
References: <200806091541.43899.u.luckas@road.de> <485031D5.3020606@bluewatersys.com> <20080611141852.3ccd89ea@hyperion.delvare>
In-Reply-To: <20080611141852.3ccd89ea@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806111327.09298.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008, Jean Delvare wrote:
> On Thu, 12 Jun 2008 08:13:09 +1200, Ryan Mallon wrote:
> >                               As David suggested, if i2c is needed early
> > in enough cases, why not just move it early in the link order? My patch
> > was just an alternative approach which mimics the current behaviour, but
> > makes it possible to get any i2c driver early. Why not just mark all of
> > the drivers/busses that get used on embedded devices as subsys_initcall,
> > just in case somebody needs them early?
> 
> Because this is an abuse of subsys_initcall? I guess that was
> acceptable when only a couple drivers were doing that, but making it
> official sounds bad.

How would it be an abuse?  On those systems, I2C is a "system bus"
and needs to be initialized early for the same reasons PCI gets set
up very early on PC hardware.

There's no rule saying that subsystem initialization may not include
the essential drivers -- in this case, i2c_adapter drivers.  PCI hubs
and bridges are certainly initialized very early, before module_init
code runs...

And in fact it seems a bit odd to think that initializing any bus
subsystem shouldn't be allowed to include its bus adapters.  It's
not as if the subsystem has completed initializiation until those
adapters are usable!!

- Dave

