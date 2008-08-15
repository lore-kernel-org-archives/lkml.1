Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbYHODKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbYHODKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 23:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbYHODJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 23:09:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:34204 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbYHODJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 23:09:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,213,1217833200"; 
   d="scan'208";a="370869100"
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
From: Zhang Rui <rui.zhang@intel.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       rusty@rustcorp.com.au
In-Reply-To: <48A4F05B.9050309@linux.intel.com>
References: <20080814172945.250a27f2.sfr@canb.auug.org.au>
	 <20080814083828.d10e126d.randy.dunlap@oracle.com>
	 <20080814154456.GA26388@kroah.com>  <48A4F05B.9050309@linux.intel.com>
Content-Type: text/plain
Date: Fri, 15 Aug 2008 11:09:32 +0800
Message-Id: <1218769772.3209.46.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-15 at 04:56 +0200, Andi Kleen wrote:
> Greg KH wrote:
> > On Thu, Aug 14, 2008 at 08:38:28AM -0700, Randy Dunlap wrote:
> >> calling  param_sysfs_init+0x0/0x1e7
> >> ------------[ cut here ]------------
> >> WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x35/0x3d()
> >> sysfs: duplicate filename 'acpi' can not be created
> > 
> > Why would this be a sysfs error, it's acpi doing something foolish,
> > that's why the sysfs layer is warning about it :)
> 
> The NULL pointer reference further down actually looks like something
> foolish in the sysfs layer. But actually ACPI is not doing
> anything wrong here I think. According to the backtrace it happens
> when a kernel param (aka module_param) is set. And creating multiple
> params in the same acpi space is completely legal.
> 
> It looks more like the high level code that sets up these parameters
> broke somehow and starts registering these twice and now ACPI is the
> first one to hit it (maybe because it starts with 'a' :-). 
Perhaps we could try "acpi=off" and see if it still happens.

thanks,
rui



