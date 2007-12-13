Return-Path: <linux-kernel-owner+w=401wt.eu-S1763528AbXLMRdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763528AbXLMRdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbXLMRdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:33:03 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757514AbXLMRdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:33:00 -0500
Date: Thu, 13 Dec 2007 12:30:41 -0500
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Lord <lkml@rtr.ca>, akpm@linux-foundation.org, mlord@pobox.com,
       rjw@sisk.pl, tglx@linutronix.de, torvalds@linux-foundation.org,
       stable@kernel.org, stable-commits@vger.kernel.org
Subject: Re: patch revert-fix-smp-poweroff-hangs.patch queued to -stable
	tree
Message-ID: <20071213173041.GB28148@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	linux-kernel@vger.kernel.org, Mark Lord <lkml@rtr.ca>,
	akpm@linux-foundation.org, mlord@pobox.com, rjw@sisk.pl,
	tglx@linutronix.de, torvalds@linux-foundation.org,
	stable@kernel.org, stable-commits@vger.kernel.org
References: <20071213053020.E28AB1454450@imap.suse.de> <4761601B.3030408@rtr.ca> <20071213164545.GA10593@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213164545.GA10593@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 08:45:45AM -0800, Greg KH wrote:
 > >> There still is a remaining shutdown problem in 2.6.22 with old APM based
 > >> systems, but this fix is not the correct one
 > > ..
 > >
 > > Eh?  It may not fix APM systems, but it *does* fix several known examples
 > > of ACPI systems.
 > 
 > And I have a large number of real systems that this patch has caused
 > problems with.  So much so that we had to revert it from a shipping SuSE
 > product already, so I figured it was safe to also revert this in
 > mainline as it did cause regressions.

Cheesy, but why not something like..

+	if (acpi_enabled)		// Or whatever the var name is these days
+		disable_nonboot_cpus();

until we find out more?

	Dave

-- 
http://www.codemonkey.org.uk
