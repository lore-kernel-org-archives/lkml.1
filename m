Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbYDSGRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbYDSGRm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 02:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYDSGRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 02:17:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63748 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbYDSGRe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 02:17:34 -0400
Subject: Re: [RFC PATCH try2] sysfs: add /sys/dev/{char,block} to
	lookupsysfs path by major:minor
From: Kay Sievers <kay.sievers@vrfy.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Greg KH <greg@kroah.com>, Mark Lord <lkml@rtr.ca>,
       NeilBrown <neilb@suse.de>, SL Baur <steve@xemacs.org>,
       Tejun Heo <htejun@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1208565705.5083.27.camel@dwillia2-linux.ch.intel.com>
References: <1208547223.5083.17.camel@dwillia2-linux.ch.intel.com>
	 <1208552034.8589.16.camel@lov.site>
	 <1208565705.5083.27.camel@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 19 Apr 2008 08:16:58 +0200
Message-Id: <1208585818.8589.36.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX1+mUKSpDEUzYUVAq+Z4Lr6+6FWrWE+n5PntzAD
 jfHqGnKaSUXfTlL0vMD+1todZxM+a4nmucDePBkx1Fb9NX6ClS
 2r3V48BCE3ZTYypr+i/wz6ctJlM3gqa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-18 at 17:41 -0700, Dan Williams wrote:
> On Fri, 2008-04-18 at 13:53 -0700, Kay Sievers wrote:
> > On Fri, 2008-04-18 at 12:33 -0700, Dan Williams wrote:
> > Also:
> >   class_create(THIS_MODULE, "usb_device");
> > in:
> >   drivers/usb/core/devio.c
> > should probably clear the dev_kobj after registration, and we can get
> > rid of the "parent has the same dev_t" logic?
> 
> Greg had suspicions that there might be more cases like
> usb_classdev_class, so I added a dev_warn() to help debug those.

Yeah, it's Linux, you never know. :) But there are no currently known
other subsystem doing this. It is perfectly ﻿valid scenario though, to
have that, if someone comes up with a better idea as some current stuff
is doing it, and we need to deprecate something, and have duplicated
dev_t entries in sysfs for a while.

> I don't mind taking your word for it that there are no more such cases,
> but maybe the warning should stay in for a few -rc releases?

I think, we can remove that, as it will print a warning for the
"duplicate entry" anyway.

Looks all fine now from my point of view.

Thanks,
Kay

