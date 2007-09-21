Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbXIUIhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbXIUIhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 04:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbXIUIhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 04:37:43 -0400
Received: from mo-p07-ob.rzone.de ([81.169.146.188]:62173 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbXIUIhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 04:37:42 -0400
From: Stefan Rompf <stefan@loplof.de>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [RFC][PATCH 0/2 -mm] kexec based hibernation -v3
Date: Fri, 21 Sep 2007 10:43:37 +0200
User-Agent: KMail/1.9.5
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
References: <1190266440.21818.16.camel@caritas-dev.intel.com>
In-Reply-To: <1190266440.21818.16.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709211043.38266.stefan@loplof.de>
X-RZG-AUTH: kR2YrGeU3i5IZ7e/KoXXySNh16uouyfpvuAE9NRyohxnu02Esi3rXc5iPGqGAW2013w=
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 20. September 2007 07:34 schrieb Huang, Ying:

> The hibernation procedure with the patch set is as follow:
>
> 1. Boot a kernel A
>
> 2. Work under kernel A
>
> 3. Kexec another kernel B (crash dump enabled) in kernel A.

>From a short glance over current Linus' arch/i386/kernel/machine_kexec.c, 
memory for the crash dump kernel B still needs to be reserved statically when 
booting A.

This is one of the biggest issues with kexec based hibernation. For the 
typical notebook user, it is totally unacceptable to reserve 16 megabytes of 
memory just to be able to suspend to disk. And given the fact that current 
distribution kernels are quite modular and require early module loading, even 
more memory might be needed.

IMHO, a plan how to fix this must exist or the concept of kexec based 
hibernation is a waste of time.

Stefan
