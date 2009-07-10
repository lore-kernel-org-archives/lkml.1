Return-Path: <linux-kernel-owner+w=401wt.eu-S1752738AbZGJC5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbZGJC5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 22:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbZGJC5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 22:57:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:16558 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbZGJC5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 22:57:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,376,1243839600"; 
   d="scan'208";a="428996473"
Subject: Re: 2.6.30 oops with acpi/button
From: ykzhao <yakui.zhao@intel.com>
To: "Stephen J. Gowdy" <gowdy@cern.ch>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.0907090806560.5445@localhost.localdomain>
References: <alpine.LRH.2.00.0907090806560.5445@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Organization: Intel Open Source Technology Center
Date: Fri, 10 Jul 2009 10:57:44 +0800
Message-Id: <1247194664.3568.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 16:29 +0800, Stephen J. Gowdy wrote:
> Hi Len & Bjorn,
>  	I've not had time to go back to it but with 2.6.30 I get an oops 
> when I close the lid on my HP Compaq 6910p laptop. I see you removed some 
> null pointer checks.. perhaps tha tis why? Here is the oops extracted from 
> my log file. If you want me to test a patch let me know. I'm about to try 
> 2.6.30.1 but I don't see anything in the ChangeLog that is likely to make 
> a difference.
>  	I've gone back to 2.6.29.4 where it is fine. I tried unloading the 
> "button" module first but in that case my laptop locked up without an 
> oops. No flashing num/caps lock or anything, just froze when I close the 
> lid. The version of button.c from 2.6.29.4  doesn't compile in the 2.6.30 
> tree;
> 
> drivers/acpi/button.c: In function ‘acpi_button_add_fs’:
> drivers/acpi/button.c:203: error: ‘struct proc_dir_entry’ has no member 
> named ‘owner’
> drivers/acpi/button.c:208: error: ‘struct proc_dir_entry’ has no member 
> named ‘owner’
> drivers/acpi/button.c: In function ‘acpi_button_init’:
> drivers/acpi/button.c:525: error: ‘struct proc_dir_entry’ has no member 
> named ‘owner’
The proc_dir_entry::owner member is removed after the following commit
is shipped:
    commit 99b76233803beab302123d243eea9e41149804f3
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Wed Mar 25 22:48:06 2009 +0300

    proc 2/2: remove struct proc_dir_entry::owner

It seems that the owner member is already removed in the button driver.
Why does the above issue still exist?

Will you please try the latest kernel and see whether the issue still
exists?

For the LID oops issue on the HP6910P, will you please enable
"CONFIG_DRM_I915_KMS" in kernel configuration and see whether the issue
still exists? This had better be done in the latest kernel(for example:
2.6.31-rc1/2)

thanks.
   Yakui

> 
>  	Any ideas?
> 
> 
>  						regards,
> 
>  						Stephen.
> 
> -- 
>   /------------------------------------+-------------------------\
> |Stephen J. Gowdy                     | CERN       Office: 8-1-11|
> |http://cern.ch/gowdy/                | CH-1211 Geneva 23        |
> |                                     | Switzerland              |
> |EMail: gowdy@cern.ch                 | Tel: +41 76 487 2215     |
>   \------------------------------------+-------------------------/

