Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbZHFBwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbZHFBwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 21:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbZHFBwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 21:52:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:3594 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbZHFBwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 21:52:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,331,1246863600"; 
   d="scan'208";a="436548647"
Subject: Re: [PATCH 0/3] Generic sysfs support for ACPI ALS and other ALS
	devices
From: Zhang Rui <rui.zhang@intel.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Cc: Greg KH <greg@kroah.com>, Pavel Machek <pavel@ucw.cz>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <19291.1249488631@turing-police.cc.vt.edu>
References: <1249290657.2670.250.camel@rzhang-dt>
	 <20090804132129.GH18974@elf.ucw.cz> <20090804151042.GA20276@kroah.com>
	 <19631.1249406664@turing-police.cc.vt.edu>
	 <20090804173627.GA23848@kroah.com> <1249434292.2670.388.camel@rzhang-dt>
	 <19291.1249488631@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 09:51:41 +0800
Message-Id: <1249523501.2670.490.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 00:10 +0800, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 05 Aug 2009 09:04:52 +0800, Zhang Rui said:
> > On Wed, 2009-08-05 at 01:36 +0800, Greg KH wrote:
> > > On Tue, Aug 04, 2009 at 01:24:24PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > > > On Tue, 04 Aug 2009 08:10:42 PDT, Greg KH said:
> > > > > On Tue, Aug 04, 2009 at 03:21:29PM +0200, Pavel Machek wrote:
> > > > > > On Mon 2009-08-03 17:10:57, Zhang Rui wrote:
> > > > 
> > > > > > > 	cat /sys/class/als/als0/mappings
> > > > > > > 	???Illuminance	Adjustment
> > > > > > > 	          0	       70
> > > > > > > 	         10	       73
> > > > > > > 	         80	       85
> > > > > > > 	        300	      100
> > > > > > > 	       1000	      150
> > > > > > 
> > > > > > There's one value per file for sysfs... You should definitely have th
> e
> > > > > > header. 
> > > > > 
> > > > > No, no "header", just don't do this, it's not allowed. Again,
> > > > > one-value-per-sysfs-file is the rule, please do not violate it.
> > > > 
> > > > What's the intended sysfs solution here, then? Make 'mappings' a directory,
> > > > and populate it with files called 0, 10, 80, 300, 1000, each with one number
> > > > in them?
> > > 
> > > That's one acceptable solution.  Or how about files in this directory
> > > called "mapping_0", "mapping_10", and so on, containing the adjustment
> > > value?
> > > 
> > great. that's what I'm going to do.
> > refreshed patch will be sent out later. :)
> 
> Hmm. whether to call the files mapping_0, mapping_10 etc or mapping/0, mapping/10
> etc probably depends on how nailed-down the 0,10,80,300,100 is - are those
> numbers carved in stone, 

no, these values can even change at run time.

> or are we better off defining the API as "directory
> mapping, and files for whatever values the hardware happens to cough up?"
> 
hmm, I'd prefer mappings0/{illuminance, adjustment},
mappings1/{illuminance, adjustment}...

in this case, all the illuminance/adjustment files can share the same
kobj_attribute.

thanks,
rui

