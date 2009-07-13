Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbZGMRCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbZGMRCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZGMRCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:02:38 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:31671 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbZGMRCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:02:37 -0400
Date: Mon, 13 Jul 2009 10:02:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org
Subject: Re: linux-next: Tree for July 13 (staging/usbip)
Message-Id: <20090713100242.f09c044b.randy.dunlap@oracle.com>
In-Reply-To: <20090713093443.4d3ecfb1.randy.dunlap@oracle.com>
References: <20090713180524.72f613dc.sfr@canb.auug.org.au>
	<20090713085915.6bbd4879.randy.dunlap@oracle.com>
	<20090713162511.GB22074@suse.de>
	<20090713093443.4d3ecfb1.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4A5B68A2.01DA:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 09:34:43 -0700 Randy Dunlap wrote:

> On Mon, 13 Jul 2009 09:25:11 -0700 Greg KH wrote:
> 
> > On Mon, Jul 13, 2009 at 08:59:15AM -0700, Randy Dunlap wrote:
> > > On Mon, 13 Jul 2009 18:05:24 +1000 Stephen Rothwell wrote:
> > > 
> > > > Hi all,
> > > > 
> > > > Changes since 20090710:
> > > 
> > > 
> > > drivers/staging/usbip/usbip_common.c: In function 'usbip_thread':
> > > drivers/staging/usbip/usbip_common.c:386: error: implicit declaration of function 'lock_kernel'
> > > drivers/staging/usbip/usbip_common.c:390: error: implicit declaration of function 'unlock_kernel'
> > > 
> > > config attached.
> > 
> > Odd, that code has not changed at all.
> > 
> > Did we just loose the big kernel lock somehow?
> 
> I dunno.  Probably some header file cleanup thing.  :(
> 
> Looks like only linux/smp_lock.h #defines it, but a driver shouldn't
> need to #include that file IMHO.

Adding
#include <linux/smp_lock.h>
does fix the build error, but I don't like it.

---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
