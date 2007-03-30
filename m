Return-Path: <linux-kernel-owner+w=401wt.eu-S1750945AbXC3SSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945AbXC3SSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbXC3SSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:18:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:43358 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXC3SSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:18:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=crQQPrr0OLVnS2KBoj5zWx6QbTg2woVA8esV9PTqqv2ZRhiQiQyR9oE1LvUKHTtIJwBIV7uWhgsW7M1sgg7y0flpAq+7a7dgznumvwGgN8XyXpZyrWweC4OX2ZVqrZPBH5+5+ZvMFPchTGl7gvAif9RviU0DzcmTvyy9NuJy348=
Message-ID: <d120d5000703301118j7db6813dt441ffd2ec36fb6cc@mail.gmail.com>
Date: Fri, 30 Mar 2007 14:18:30 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "James Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Cc: "Tejun Heo" <htejun@gmail.com>, gregkh@suse.de, hugh@veritas.com,
       cornelia.huck@de.ibm.com, oneukum@suse.de, maneesh@in.ibm.com,
       rpurdie@rpsys.net, "Jeff Garzik" <jgarzik@pobox.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "SCSI Mailing List" <linux-scsi@vger.kernel.org>
In-Reply-To: <1175277501.3760.32.camel@mulgrave.il.steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <460CDBA6.5030608@gmail.com>
	 <1175257751.3760.19.camel@mulgrave.il.steeleye.com>
	 <d120d5000703300615y7b367d82hb42f1c58ca8a6328@mail.gmail.com>
	 <1175277501.3760.32.camel@mulgrave.il.steeleye.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/07, James Bottomley <James.Bottomley@steeleye.com> wrote:
> On Fri, 2007-03-30 at 09:15 -0400, Dmitry Torokhov wrote:
> > If you want to manage lifetime rules independently you might want to
> > not embed struct device into you subsystems objects but attach them
> > via pointers and use device_create(). Now that we orphan sysfs access
> > upon unregistering device this will severe all ties from driver core
> > to your system once you start teardown of a device and you should be
> > in clear.
>
> But that wouldn't really help ... all objects have lifetimes.  What
> Tejun is pointing out is that we have two different lifetime
> requirements:  driver internal (and subsystem) objects and sysfs
> objects ...

Exactly. If driver-private data structures have different lifetime
than device abstractions (like they seem to have with scsi and ide)
then you split them and refcount separately. We are just arguing where
to put the line. You want to split devices and kobjects and rework
infrastructure and I am saying that we already have infrastructure we
need and that split shoud be between generic device structure and
driver-managed device structure.

-- 
Dmitry
