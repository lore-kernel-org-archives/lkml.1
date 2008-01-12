Return-Path: <linux-kernel-owner+w=401wt.eu-S1763387AbYALJ5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763387AbYALJ5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 04:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760832AbYALJ5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 04:57:01 -0500
Received: from smtp-106-saturday.nerim.net ([62.4.16.106]:61412 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760646AbYALJ5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 04:57:00 -0500
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Jan 2008 04:57:00 EST
Date: Sat, 12 Jan 2008 10:56:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Shaohua Li <shaohua.li@intel.com>,
       Mike Houston <mikeserv@bmts.com>, Adrian Bunk <bunk@stusta.de>,
       Elvis Pranskevichus <el@prans.net>, mhoffman@lightlink.com,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Adam Belay <ambx1@neo.rr.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Thomas Renninger <trenn@suse.de>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.24-rc4 hwmon it87 probe fails
Message-ID: <20080112105658.6fb3995f@hyperion.delvare>
In-Reply-To: <4769C0E2.4000500@shaw.ca>
References: <fa.QPUBl9Xd2PDsImgWn6hbR+ShV1U@ifi.uio.no>
	<fa.ri5Klmu4+MwjYC8x5nSms+xKXfI@ifi.uio.no>
	<fa.B/J+j9kGGZ1+gW9FrfHky+cj0Eo@ifi.uio.no>
	<fa.Xv3BmMxnCGLOeEijySte5mKDO5k@ifi.uio.no>
	<4769C0E2.4000500@shaw.ca>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On Wed, 19 Dec 2007 19:09:54 -0600, Robert Hancock wrote:
> It's quite possible that the BIOS accesses the device either from ACPI 
> AML or possibly even from SMI. In that case it would be quite reasonable 
> for the BIOS to reserve that region to prevent another driver from 
> loading and trying to take conflicting control of the device. One has to 
> be careful before assuming that any such reservation is bogus.

Again I am all for honoring such BIOS requests so as to prevent
conflicts between ACPI or SMI and native drivers. The problem is that
no two BIOS out there do the same in this respect. I couldn't see any
correlation between machines declaring their hwmon device in PNP and
machines where ACPI or SMI access the device in question. Many boards
declare their device and seemingly never touch it so it's fine for
Linux to drive them. Some boards no not declare the devices but still
access them in our back.

Thomas' patches should deal with the ACPI AML case in most cases, but
not with SMI.

So either the PNP code in Linux isn't exporting enough details to
differentiate, or even the PNP code has no way to tell these cases
apart. In the latter case there's not much we can do. In the former
case, let's have the PNP code export the information so that hwmon
drivers can decide whether they should bind to the devices or not by
default.

-- 
Jean Delvare
