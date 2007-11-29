Return-Path: <linux-kernel-owner+w=401wt.eu-S1762140AbXK2Kxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762140AbXK2Kxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbXK2Kxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:53:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:60743 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbXK2Kxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:53:43 -0500
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
From: Kay Sievers <kay.sievers@vrfy.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20071129103510.5d2fda63@gondolin.boeblingen.de.ibm.com>
References: <20071127230252.GB10038@kroah.com>
	 <20071128124545.39ae8070@gondolin.boeblingen.de.ibm.com>
	 <1196252582.3242.28.camel@lov.site>
	 <20071128164842.70caa396@gondolin.boeblingen.de.ibm.com>
	 <1196265468.3242.60.camel@lov.site>
	 <20071128171238.1ef5d076@gondolin.boeblingen.de.ibm.com>
	 <1196267789.3242.87.camel@lov.site>
	 <20071128175108.5a370684@gondolin.boeblingen.de.ibm.com>
	 <1196269227.3242.93.camel@lov.site> <20071129060821.GF26327@kroah.com>
	 <1196322631.3242.198.camel@lov.site>
	 <20071129103510.5d2fda63@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 11:53:39 +0100
Message-Id: <1196333619.3242.210.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/FuJJDUCKm7CiQw7kSDh9JQDJysFFrR3+CyEu
 pPUQQzxLQUVf62WSiFJevUxT28uOi+WESVhrQ2cIqdq03Rpz3q
 TqvxMFZlOnPGjmXLQk1qM4i/ZzH+97m
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-29 at 10:35 +0100, Cornelia Huck wrote:
> On Thu, 29 Nov 2007 08:50:31 +0100,
> Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > We have ~20 callers of kobject_(un)register(), convert them to
> > kobject_init() + kobject_add() + kobject_uevent(), and just delete the
> > broken kobject_(un)register() functions from the kobject code.
> 
> I find a bit more callers in my tree, but it still isn't too many.

You are right, there are 27 files.

> This may also be a good time to evaluate which of those kobjects really
> need a uevent. For example, I can imagine that you don't need a uevent
> for a directory being created, but only for the objects created in that
> directory.

True, most plain directories don't need an event (and usually don't have
one today), because the kset does not match, like the "holders/slaves"
directories, or the "glue directories" between bus and class devices. 

But for example the bus/class directories, there we really want an
uevent (and have one today) to set bus specific defaults when the
bus/class gets created.

Thanks,
Kay

