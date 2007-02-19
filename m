Return-Path: <linux-kernel-owner+w=401wt.eu-S932390AbXBSQga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbXBSQga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 11:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932396AbXBSQg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 11:36:29 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:24126 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbXBSQg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 11:36:29 -0500
In-Reply-To: <1171759045.5644.148.camel@localhost.localdomain>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>, johnrose@us.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       pmac@au1.ibm.com, Sylvain Munaut <tnt@246tnt.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2.6.21-rc1] powerpc: Make of_device_uevent()	compatible	with
 ibmebus
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF18F067AE.FF85D78B-ON85257287.005ADAC3-85257287.005B37D9@de.ibm.com>
Date: Mon, 19 Feb 2007 11:36:23 -0500
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 19/02/2007 17:36:24,
	Serialize complete at 19/02/2007 17:36:24
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote on 17.02.2007 
19:37:25:

> > > Doh ! You are creating an of_device with no attached device-node ? 
That
> > > is totally evil ! Why do you need that ?
> > 
> > The driver creates a fake "ibmebus" device so all ibmebus based 
devices 
> > have
> > a common parent device -- the vio bus does the same.
> > 
> > What do you think about linking this device to the device tree "/" 
node? 
> > All
> > ibmebus-based devices are linked to dt nodes residing directly beneath 

> > "/",
> > so the mapping would fit.
> 
> No. If you do that, it shouldn't be an of_device based device.
> 
> If you want then to be below a common parent, then create that parent of
> a basic struct device type, that sort of thing. You should never
> instanciate an of_device that has a NULL device node.

If I make the root device a basic struct device, it can't be part of 
ibmebus any
longer. If we could create a busless device, we wouldn't have a problem, 
but I
doubt that is possible.

Do you have any creative ideas?
 
> It's a generic problem with sysfs, I agree it somewhat sucks.

With ya.

Later,
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
