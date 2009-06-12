Return-Path: <linux-kernel-owner+w=401wt.eu-S1765446AbZFLRna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765446AbZFLRna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbZFLRnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:43:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:28987 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbZFLRnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:43:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,210,1243839600"; 
   d="scan'208";a="421251257"
Subject: Re: [BUG][2.6.30] Niced processes do not raise CPU frequency with
 ondemand
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <200906121925.38693.elendil@planet.nl>
References: <200906121844.02004.elendil@planet.nl>
	 <1244825317.4534.1342.camel@localhost.localdomain>
	 <200906121925.38693.elendil@planet.nl>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 10:41:48 -0700
Message-Id: <1244828508.4534.1404.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 10:25 -0700, Frans Pop wrote:
> Thanks for the quick reply Venki.
> 
> On Friday 12 June 2009, Pallipadi, Venkatesh wrote:
> > What does ignore_nice under cpufreq/ondemand say?
> 
> Right, that's 1 (was not aware that existed :-P)
> And changing it to 0 solves the problem.

OK. Good to know that there are no kernel bugs with honoring
ignore_nice_load setting. :)
 
> Next question is: how and why does it get set?
> As userland has not changed (AFAIK), my first suspect remains the kernel.
> 

Kernel never sets this. It is initialized to 0 and provides a /sys
interface to user. I think it is set by some user app
(gnome-power-manager or some other app like that). That explains why it
is 0 initially after boot and gets changed later.

The support for ignore_nice_load=1 was broken in kernel for a short
while (arounf 2.6.28, IIRC). That may be the reason why this behavior
was not noticed earlier.

Thanks,
Venki

