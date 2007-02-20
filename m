Return-Path: <linux-kernel-owner+w=401wt.eu-S1030523AbXBTWgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030523AbXBTWgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030521AbXBTWgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:36:23 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:18496 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030523AbXBTWgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:36:20 -0500
In-Reply-To: <1171992306.22669.5.camel@sinatra.austin.ibm.com>
To: John Rose <johnrose@austin.ibm.com>
Cc: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>,
       Me Notes <johnrose@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       External List <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>, Paul Mackerras <pmac@au1.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2.6.21-rc1] ibmebus: Support dynamic addition	and	removal of
 adapters
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF11FDFA50.7BF76A97-ON85257288.006AC46B-85257288.007C2AD7@de.ibm.com>
Date: Tue, 20 Feb 2007 17:36:16 -0500
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 20/02/2007 23:36:17,
	Serialize complete at 20/02/2007 23:36:17
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Rose <johnrose@austin.ibm.com> wrote on 20.02.2007 12:25:06:

> > If the probe operation succeeds, the respective device will show up 
> > beneath
> > /sys/bus/ibmebus/devices.
> 
> This approach is not particularly synchronous.  Take the case of an add
> failure: how long would an application wait before deciding that the new
> device is not going to appear?
>
> It might be preferable to have the write to the probe function fail. 
> For example, if we can't find the device node, return -EINVAL or
> something.

Can be done, sure. Just a matter of putting some more sophisticated error
handling into my code. Patch follows in a bit.
 
> > This is already taken care of by of_device_register().
> 
> If we are scrapping the use of of_device for ibmebus devices, can we
> still create a devspec file for OF correlation purposes?

We don't. My recent patch only changes the fake root device.
Ibmebus-based devices will still be of_devices, of course.

Regards,
  Joachim

---
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com  --  Phone: +49 7031 16 1239 

Sitz der Gesellschaft: Böblingen  --  Geschftsfhrung: Herbert Kircher
Vorsitzender des Aufsichtsrats: Johann Weihen
Registergericht: Amtsgericht Stuttgart, HRB 243294
