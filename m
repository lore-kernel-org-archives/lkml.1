Return-Path: <linux-kernel-owner+w=401wt.eu-S933952AbZGQBj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952AbZGQBj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 21:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933935AbZGQBjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 21:39:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:51305 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933932AbZGQBjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 21:39:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,414,1243839600"; 
   d="scan'208";a="475653520"
Subject: Re: [PATCH 0/8] device async action mechanism
From: Zhang Rui <rui.zhang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <20090715002916.GC2360@ucw.cz>
References: <1247643512.26272.74.camel@rzhang-dt>
	 <20090715002916.GC2360@ucw.cz>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 09:40:13 +0800
Message-Id: <1247794814.26272.216.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 08:29 +0800, Pavel Machek wrote:
> Hi!
> 
> I notice you are still ccing my @suse.cz address. That one no longer
> works :-(. 
> 
> > this is the patch set I made to speed up the device
> > suspend/resume/shutdown process.
> > 
> > A new mechanism called Device Async Actions is introduced in this patch set.
> > The basic idea is that,
> > 1. device declares to support certain kinds of device async action,
> >    like suspend, resume, shutdown, etc.
> > 2. a async domain is create for this device
> > 3. the child device inherits the async domain
> > 4. devices in the same domain suspend/resume/shutdown asynchronously with
> >    the other devices.
> > 
> > Currently, in order to make sure that it won't bring any side effects,
> > I only convert the ACPI battery and i8042 to use this framework, which reduces
> > 0.5s+ S3 time(suspend time plus resume time)???, from 7.0s to less than 6.5s.
> > and about 0.5s shutdown time in my test.
> 
> Hmm, 7seconds is still quite long. What hw is that?
> 
7 seconds including both kernel suspend and resume time.
it takes about 3.2s to suspend and 3.8 seconds to resume.

thanks,
rui

