Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbYC0DKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbYC0DKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 23:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbYC0DJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 23:09:59 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1067 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758027AbYC0DJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 23:09:55 -0400
Date: Wed, 26 Mar 2008 23:09:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and
 hibernation callbacks (rev. 4)
In-Reply-To: <200803270212.36465.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803262305580.21714-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008, Rafael J. Wysocki wrote:

> @@ -68,22 +75,32 @@ int device_pm_add(struct device *dev)
>  		 dev->bus ? dev->bus->name : "No Bus",
>  		 kobject_name(&dev->kobj));
>  	mutex_lock(&dpm_list_mtx);
> -	if ((dev->parent && dev->parent->power.sleeping) || all_sleeping) {
> -		if (dev->parent->power.sleeping)
> -			dev_warn(dev,
> -				"parent %s is sleeping, will not add\n",
> +	if (dev->parent) {
> +		if (dev->parent->power.status >= DPM_SUSPENDING) {
> +			dev_warn(dev, "parent %s is sleeping, will not add\n",
>  				dev->parent->bus_id);

You forgot to check for dev->parent->power.status == DPM_INVALID.

Alan Stern

