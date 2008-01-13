Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbYAMRk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbYAMRk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 12:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYAMRkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 12:40:20 -0500
Received: from smtp-100-sunday.nerim.net ([62.4.16.100]:54743 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753096AbYAMRkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 12:40:19 -0500
Date: Sun, 13 Jan 2008 18:40:17 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Jon Smirl" <jonsmirl@gmail.com>
Cc: "Greg KH" <greg@kroah.com>, linuxppc-dev@ozlabs.org, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Implement module aliasing for i2c to translate from
 device tree names
Message-ID: <20080113184017.7e3b409f@hyperion.delvare>
In-Reply-To: <9e4733910801130824i547b65a9n64e415f9626d6ab5@mail.gmail.com>
References: <20071220044136.20091.70984.stgit@terra.home>
	<20071220044138.20091.31417.stgit@terra.home>
	<20080111202015.65c3c160@hyperion.delvare>
	<20080112094658.197acb08@hyperion.delvare>
	<9e4733910801120826haa8905dk863ed1c8e9f420c9@mail.gmail.com>
	<20080113154114.4a1c5166@hyperion.delvare>
	<9e4733910801130824i547b65a9n64e415f9626d6ab5@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2008 11:24:29 -0500, Jon Smirl wrote:
> On 1/13/08, Jean Delvare wrote:
> > On Sat, 12 Jan 2008 11:26:34 -0500, Jon Smirl wrote:
> > > IMHO, driver_name/type should be removed in new style drivers and
> > > replaced with aliases on all platforms since aliases are the standard
> > > kernel mechanism.
> >
> > I agree. But we can take your aliasing code now (once you have
> > addressed the issues I raised) and convert the users of driver_name
> > later; it doesn't have to be done all at once.
> 
> GregKH, adding a new dynamically loadable subsystem is not something
> that happens every day, can you check to make sure all of the standard
> kernels mechanisms are being used? I'm not totally sure how the
> modalias naming code is supposed to be done. The subsystem core code
> in these patches needs review.
> 
> Jean, could you take over the i2c core portion of the patch? That will
> let you decide exactly how you want the driver_name/name fields to be
> dealt with. After you get standard naming support into i2c core I'll
> rework the rest of the patch to use your new code.

Yes, that could be done, and I agree that it will probably be faster
than iterative review/rework cycles between you and me. I'll free some
cycles next week for that.

> I don't think driver_name/name fields should be stored in an i2c
> structure at all. They are redundant with the standard mechanism.
> 
> The kernel automatically exposes modalias as a sysfs attribute so the
> string must be recorded further down in the driver support layers. No
> need to keep a copy in the i2c structure.

Really? I didn't know that. So that's another thing that the i2c
subsystem is not doing like the rest of the kernel? Can you please
point me to the code that does this?

> Standard devices don't export a 'name' attribute. To see the driver
> name for a device in sysfs look at the 'driver' link.

The driver name and the device name are different things! The "name"
attribute that i2c devices have tells user-space the device name, not
the driver name.

You may not like what the i2c subsystem does but you can't ignore its
history. The name attribute of i2c devices has been there pretty much
forever and user-space relies on it, thus we can't remove it.

-- 
Jean Delvare
