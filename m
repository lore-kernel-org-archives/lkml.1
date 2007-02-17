Return-Path: <linux-kernel-owner+w=401wt.eu-S932623AbXBQCYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623AbXBQCYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 21:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932641AbXBQCYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 21:24:47 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:62346 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623AbXBQCYq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 21:24:46 -0500
In-Reply-To: <45D4BE7E.7000109@246tNt.com>
To: Sylvain Munaut <tnt@246tNt.com>
Cc: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>, johnrose@us.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       pmac@au1.ibm.com
MIME-Version: 1.0
Subject: Re: [PATCH 2.6.21-rc1] ibmebus: Support dynamic addition and removal of
	adapters
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OFD4D98910.EB8251E4-ON85257285.000A5EF1-85257285.000D3F8C@de.ibm.com>
Date: Fri, 16 Feb 2007 21:24:43 -0500
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 6.5.5HF882 | September 26, 2006) at
 17/02/2007 03:24:43,
	Serialize complete at 17/02/2007 03:24:43
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sylvain Munaut <tnt@246tNt.com> wrote on 15.02.2007 15:11:42:

> Mmmh, I posted a patch that added a common uevent interface for all
> of_device based bus. And that kinda clash with this one.

Oops, I was not aware of this. I had a look at your patch and yes, it's a 
nice
and generic interface. I concur that using your generic function is the 
better
approach.

> But as "ibm,loc_code" is local to this bus it's not handled by my code.
> Is it necessary to match the correct driver ?

The intention of adding the location code was to include a device property
into the environment that's unique to each device. Actually, the DEVPATH 
variable
provides exactly this: For ebus devices, it points to the ebus device 
itself,
which natually is unique.

If a userspace tool really needs the location code, the "devspec" 
attribute of
the ebus device will point it to the device tree node, which in turn 
contains the
location code property.

So I think there's nothing preventing me from using your function. Thanks 
for
pointing this out.

Regards,
  Joachim

---
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer 
extraordinaire
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Development 
2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com  --  Phone: +49 7031 16 1239 

Vorsitzender des Aufsichtsrats: Johann Weihen  --  Geschäftsführung: 
Herbert Kircher
Sitz der Gesellschaft: Böblingen  --  Registergericht: Amtsgericht 
Stuttgart, HRB 243294
