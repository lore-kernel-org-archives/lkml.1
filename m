Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbZJPVQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbZJPVQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 17:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZJPVQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 17:16:11 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:22280 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbZJPVQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 17:16:07 -0400
X-IMAP-Sender: achiang
Date: Fri, 16 Oct 2009 14:50:13 -0600
X-OfflineIMAP-1086817885-6c646c-494e424f582e4f7574626f78: 1255727771-0932179550876-v6.0.3
From: Alex Chiang <achiang@hp.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: lenb@kernel.org, shaohua.li@intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 1/6] ACPI: dock: clean up error handling paths in
	dock_add()
Message-ID: <20091016205013.GA24292@grease.lan>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>, lenb@kernel.org,
	shaohua.li@intel.com, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org
References: <20091014224415.18044.88208.stgit@bob.kio> <20091014224616.18044.45719.stgit@bob.kio> <20091016043618.GB11582@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091016043618.GB11582@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> Hi Alex,
> 
> On Wed, Oct 14, 2009 at 04:46:16PM -0600, Alex Chiang wrote:
> > Remove some copy/paste code in our error handling paths, which makes
> > the function smaller and slightly easier to read.
> 
> Changing individual attributes into attribute_group would greatly
> simplify the code.

Good advice, I'll do this, thanks.

> > @@ -968,11 +968,9 @@ static int dock_add(acpi_handle handle)
> >  		platform_device_register_simple(dock_device_name,
> >  			dock_station_count, NULL, 0);
> >  	dock_device = dock_station->dock_device;
> > -	if (IS_ERR(dock_device)) {
> > -		kfree(dock_station);
> > -		dock_station = NULL;
> > -		return PTR_ERR(dock_device);
> > -	}
> > +	ret = IS_ERR(dock_device) ? PTR_ERR(dock_device) : 0;
> > +	if (ret)
> > +		goto out;
> 
> I think
> 
> 	if (IS_ERR(dock_device)) {
> 		ret = PTR_ERR(dock_device);
> 		goto out;
> 	}
> 
> is more commonly used form.

Ok, I'll change to the more idiomatic form.

Thanks for the review.

/ac

