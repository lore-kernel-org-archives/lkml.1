Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbZIXCFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbZIXCFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 22:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZIXCFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 22:05:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:27642 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbZIXCFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 22:05:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,441,1249282800"; 
   d="scan'208";a="729670560"
Subject: Re: [RFC] [PATCH 2/2] ACPI: introduce ACPI ALS device driver
From: Zhang Rui <rui.zhang@intel.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "Cory T. Tusar" <ctusar@videon-central.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <4AB9D82F.3030706@cam.ac.uk>
References: <1253590777.15763.22.camel@rzhang-dt>
	 <4AB8C945.8050309@cam.ac.uk> <1253669192.15763.39.camel@rzhang-dt>
	 <4AB9D82F.3030706@cam.ac.uk>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 10:05:03 +0800
Message-Id: <1253757903.15763.80.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 16:11 +0800, Jonathan Cameron wrote:
> >> Are there any plausible race conditions associated with doing the allocation this way?
> > 
> > well, theoretically, yes.
> > simultaneous add calls may happen in hotplug case, but I don't think an
> > ACPI ALS device supports hotplug.
> That would make that point irrelevant!
> 
> Thinking further on this. What happens on a box that for some reason repeatedly inserts and
> removes this module?
> 
I don't see a problem in this case.

> This is the sort of problem idr's are meant to overcome.  They will cost you a bit
> in terms of complexity though.
> 
If we use generic names, say als0, als1, ..., it's worth using idr in
the ALS class driver.
But here, als_id is just used to fix the duplicate device name problem,
in a native ALS driver. IMO, it's overkill to implement the idr stuff.

thanks,
rui

