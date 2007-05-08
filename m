Return-Path: <linux-kernel-owner+w=401wt.eu-S968404AbXEHWcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968404AbXEHWcC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:32:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968397AbXEHWb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:31:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:27794 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966847AbXEHWb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:31:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,507,1170662400"; 
   d="scan'208";a="243514639"
Date: Tue, 8 May 2007 15:29:04 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel oops after ACPI dock initialization fails
Message-Id: <20070508152904.c52d258c.kristen.c.accardi@intel.com>
In-Reply-To: <4640F1A0.6050700@redhat.com>
References: <4640EF28.2000903@redhat.com>
	<4640F1A0.6050700@redhat.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 May 2007 17:54:40 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> Chuck Ebbert wrote:
> > In 2.6.21.1 when dock driver initialization fails it does a kfree()
> > of dock_station. (Below, this is due to some error installing a
> > notify handler.) Later when a bay is discovered it calls 
> > is_dock_device() which attempts to lock the (nonexistent)
> > dock_station. Reason is this test in is_dock_device():
> > 
> >         if (!dock_station)
> >                 return 0;
> > 
> > dock_station is 0x6b6b6b6b after being freed. Either it needs
> > to be zeroed or some other flag should be used to decide
> > whether a dock station is present...
> > 
> 
> Untested patch attached.
> 
> 
> 

Hi Chuck,
thanks for the patch, this should fix the problem.  Would you care to
resend it with a proper sign-off?

Thanks,
Kristen
