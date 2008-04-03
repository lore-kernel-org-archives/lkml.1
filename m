Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbYDCVtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbYDCVtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755632AbYDCVtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:49:31 -0400
Received: from outbound-mail-101.bluehost.com ([69.89.22.11]:41233 "HELO
	outbound-mail-101.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753537AbYDCVta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:49:30 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2008 17:49:30 EDT
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH 1/3] use new pm_ops in DRM drivers
Date: Thu, 3 Apr 2008 14:41:07 -0700
User-Agent: KMail/1.9.9
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Dave Airlie <airlied@linux.ie>
References: <200804020207.40278.rjw@sisk.pl> <200804031150.55967.jbarnes@virtuousgeek.org> <200804032323.59133.rjw@sisk.pl>
In-Reply-To: <200804032323.59133.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804031441.07703.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 03, 2008 2:23 pm Rafael J. Wysocki wrote:
> > +static int i915_poweroff(struct device *dev)
> > +{
> > +	/* Shut down the device */
> > +	pci_disable_device(dev->pdev);
> > +	pci_set_power_state(dev->pdev, PCI_D3hot);
>
> I think you may need to do that in ->suspend() too, as opposed to
> ->freeze(), ...

Because ->poweroff won't be called in the paths that do ->suspend?  Ah yeah, 
must have skipped over that section of the documentation...

>
> > +}
> > +
> > +static struct pm_ops i915_pm_ops = {
> > +	.prepare = NULL, /* DRM core should prevent any new ioctls? */
> > +	.complete = NULL, /* required to re-enable DRM client requests */
> > +	.suspend = i915_save,
> > +	.resume = i915_restore,
> > +	.freeze = i915_save,
>
> ... so perhaps define ->suspend() as ->save() + ->poweroff()?

Yep, I can just make a wrapper for it in the driver.

Thanks a lot for making these changes to the core.  My only worry is that all 
the old-style stuff will stick around forever...  so fwiw you can add my

Acked-by:  Jesse Barnes <jesse.barnes@intel.com>

to the series.

Thanks,
Jesse
