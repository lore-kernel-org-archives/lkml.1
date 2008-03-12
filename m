Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbYCLBzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbYCLBzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 21:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbYCLBzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 21:55:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:22863 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbYCLBzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 21:55:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,483,1199692800"; 
   d="scan'208";a="217551454"
Subject: Re: [PATCH -mm] kexec jump -v9
From: "Huang, Ying" <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Vivek Goyal <vgoyal@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <200803120049.06491.rjw@sisk.pl>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	 <20080311211004.GA30164@redhat.com> <20080311232415.GA26320@elf.ucw.cz>
	 <200803120049.06491.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Mar 2008 09:55:37 +0800
Message-Id: <1205286937.29875.9.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 12 Mar 2008 01:53:51.0336 (UTC) FILETIME=[EB962680:01C883E3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-12 at 00:49 +0100, Rafael J. Wysocki wrote:
> On Wednesday, 12 of March 2008, Pavel Machek wrote:
[...]
> > 
> > Its certainly "more traditional" method of doing hibernation than
> > tricks swsusp currently plays.
> 
> What exactly are you referring to?

Long long ago, the hibernation is not done by Linux kernel itself but
BIOS (APM). Those days, kernel just does some preparation and jump to
BIOS to do the hibernation. Imagine kernel B is the hibernation BIOS,
kernel A does some prepare and jump to the BIOS (kernel B) just like the
old days.

> > Yes, I'd like these patches to go in, being able to switch kernels seems like
> > useful tool. 
> 
> No objection from me.
>  
> > Now, I guess they are some difficulties, like ACPI integration, and
> > some basic drawbacks, like few seconds needed to boot second kernel
> > during suspend.
> > 
> > ...OTOH this is probably only chance to eliminate freezer from
> > swsusp...
> 
> Some facts:
> 
> * In order to be able to do suspend (STR) without the freezer, we need to make
>   device drivers block access to devices from applications during suspend.
> * There's no reason to think that we can't use this same mechanism for
>   hibernation (the only difficulty seems to be the handling of devices used for
>   saving the image).

I think "kexec based hibernation" is the only currently available
possible method to write out image without freezer (after driver works
are done). If other process is running, how to prevent them from writing
to disk without freezing them in current implementation?

> * We need the drivers to quiesce devices to be able to do the kexec jump in the
>   first place (and to avoid races, we'll need them to block applications'
>   access to devices just like for STR, which is the sufficient condition for
>   removing the freezer).
> 
> So, I don't really think that the "freezer removal" argument is valid here.
> 
> Moreover, if this had been the _only_ argument for the $subject functionality,
> I'd have been against it.

Best Regards,
Huang Ying

