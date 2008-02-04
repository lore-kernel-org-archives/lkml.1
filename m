Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbYBDPYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbYBDPYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 10:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYBDPYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 10:24:38 -0500
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:28401 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbYBDPYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 10:24:37 -0500
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: michael@ellerman.id.au
Subject: Re: [PATCH 2/2] ehea: add memory remove hotplug support
Date: Mon, 4 Feb 2008 16:24:30 +0100
User-Agent: KMail/1.8.2
Cc: Jeff Garzik <jeff@garzik.org>, Thomas Klein <tklein@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>, netdev <netdev@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>,
       Christoph Raisch <raisch@de.ibm.com>, Marcus Eder <meder@de.ibm.com>
References: <200802041404.49960.ossthema@de.ibm.com> <1202136362.7672.5.camel@concordia>
In-Reply-To: <1202136362.7672.5.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802041624.31228.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 February 2008 15:46, Michael Ellerman wrote:
> On Mon, 2008-02-04 at 14:04 +0100, Jan-Bernd Themann wrote:
> > Add memory remove hotplug support

> > @@ -3559,6 +3578,10 @@ int __init ehea_module_init(void)
> >  	if (ret)
> >  		ehea_info("failed registering reboot notifier");
> >  
> > +	ret = register_memory_notifier(&ehea_mem_nb);
> > +	if (ret)
> > +		ehea_info("failed registering memory remove notifier");
> > 
> >  	ret = crash_shutdown_register(&ehea_crash_handler);
> >  	if (ret)
> >  		ehea_info("failed registering crash handler");
> 
> You don't do anything except print a message if the registration fails.
> What happens when someone tries to remove memory but the memory notifier
> wasn't registered properly? Bang?

In case the registration fails and somebody tries to free memory:
- Driver will not remove the affected memory from the eHEA memory region
  --> Firmware (phyp) can not free that memory (as marked as used)
  --> Therefore the removed memory could not be used in an other partition

It makes sense to allow the driver to work anyway. Having no ethernet
would not really be a good alternative.

Regards,
Jan-Bernd
