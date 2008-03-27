Return-Path: <linux-kernel-owner+w=401wt.eu-S1760659AbYC0QZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659AbYC0QZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759465AbYC0QZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:25:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45938 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757109AbYC0QZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:25:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 4)
Date: Thu, 27 Mar 2008 17:24:57 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>
References: <Pine.LNX.4.44L0.0803262305580.21714-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803262305580.21714-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803271724.59155.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 of March 2008, Alan Stern wrote:
> On Thu, 27 Mar 2008, Rafael J. Wysocki wrote:
> 
> > @@ -68,22 +75,32 @@ int device_pm_add(struct device *dev)
> >  		 dev->bus ? dev->bus->name : "No Bus",
> >  		 kobject_name(&dev->kobj));
> >  	mutex_lock(&dpm_list_mtx);
> > -	if ((dev->parent && dev->parent->power.sleeping) || all_sleeping) {
> > -		if (dev->parent->power.sleeping)
> > -			dev_warn(dev,
> > -				"parent %s is sleeping, will not add\n",
> > +	if (dev->parent) {
> > +		if (dev->parent->power.status >= DPM_SUSPENDING) {
> > +			dev_warn(dev, "parent %s is sleeping, will not add\n",
> >  				dev->parent->bus_id);
> 
> You forgot to check for dev->parent->power.status == DPM_INVALID.

Right, will fix.

Thanks,
Rafael
