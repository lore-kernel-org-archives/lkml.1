Return-Path: <linux-kernel-owner+w=401wt.eu-S1760823AbXGDNXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823AbXGDNXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 09:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758916AbXGDNXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 09:23:07 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:3897 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758570AbXGDNXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 09:23:04 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: "Akinobu Mita" <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/2] eHEA: Capability flag for DLPAR support
Date: Wed, 4 Jul 2007 14:58:11 +0200
User-Agent: KMail/1.8.2
Cc: "Jeff Garzik" <jeff@garzik.org>, netdev <netdev@vger.kernel.org>,
       "Christoph Raisch" <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, "Marcus Eder" <meder@de.ibm.com>,
       "Thomas Klein" <tklein@de.ibm.com>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>
References: <200707041209.37127.ossthema@de.ibm.com> <961aa3350707040553m12ff1bccw9421e714337c80d1@mail.gmail.com>
In-Reply-To: <961aa3350707040553m12ff1bccw9421e714337c80d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041458.12792.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

good catch.

Thanks

On Wednesday 04 July 2007 14:53, Akinobu Mita wrote:
> 2007/7/4, Jan-Bernd Themann <ossthema@de.ibm.com>:
> 
> > diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
> > index bdb5241..f8c0908 100644
> > --- a/drivers/net/ehea/ehea_main.c
> > +++ b/drivers/net/ehea/ehea_main.c
> > @@ -2923,6 +2923,15 @@ static int check_module_parm(void)
> >         return ret;
> >  }
> >
> > +static ssize_t ehea_show_capabilities(struct device_driver *drv,
> > +                                     char *buf)
> > +{
> > +       return sprintf(buf, "%d", EHEA_CAPABILITIES);
> > +}
> > +
> > +static DRIVER_ATTR(capabilities, S_IRUSR | S_IRGRP | S_IROTH,
> > +                  ehea_show_capabilities, NULL);
> > +
> >  int __init ehea_module_init(void)
> >  {
> >         int ret;
> > @@ -2937,12 +2946,20 @@ int __init ehea_module_init(void)
> >         if (ret)
> >                 ehea_error("failed registering eHEA device driver on ebus");
> >
> 
> You forgot to put:
>                 return ret;
> or
>                 goto out;
> 
> > +       ret = driver_create_file(&ehea_driver.driver, &driver_attr_capabilities);
> > +       if (ret) {
> > +               ehea_error("failed to register capabilities attribute, ret=%d", ret);
> > +               ibmebus_unregister_driver(&ehea_driver);
> > +               goto out;
> > +       }
> > +
> >  out:
> >         return ret;
> >  }
> >
> 
