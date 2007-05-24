Return-Path: <linux-kernel-owner+w=401wt.eu-S1762891AbXEXDVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762891AbXEXDVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 23:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758704AbXEXDVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 23:21:14 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:62470 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758685AbXEXDVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 23:21:13 -0400
Date: Wed, 23 May 2007 20:26:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
Message-Id: <20070523202613.2ab49b77.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<46540DB2.5000605@googlemail.com>
	<Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
	<4654AC94.6080601@googlemail.com>
	<20070523150122.f9946f37.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705231526350.22666@schroedinger.engr.sgi.com>
	<20070523153730.e0e9e91d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com>
	<20070523182145.7d7f1f7e.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 20:00:52 -0700 (PDT) Christoph Lameter wrote:

> New version with Randy's fixes:

well...  :)


> Index: slub/Documentation/kernel-parameters.txt
> ===================================================================
> --- slub.orig/Documentation/kernel-parameters.txt	2007-05-23 19:34:49.000000000 -0700
> +++ slub/Documentation/kernel-parameters.txt	2007-05-23 19:58:04.000000000 -0700
> @@ -1589,6 +1589,37 @@ and is between 256 and 4096 characters. 
>  
>  	slram=		[HW,MTD]
>  
> +	slub_debug	[MM, SLUB]
> +			Enabling slub_debug allows to determine the culprit

                                            allows ___(who)____

> +			if slab objects become corrupted. Enabling slub_debug
> +			creates guard zones around objects and poisons objects
> +			when not in use. Also tracks the last alloc / free.
> +			For more information see Documentation/vm/slub.txt.
> +

> +	slub_min_order=	[MM, SLUB]
> +			Determines the mininum page order for slabs. Must be
> +			lower than slub_max_order

                                                ^.  (end with period)

> +			For more information see Documentation/vm/slub.txt.


> Index: slub/Documentation/vm/slub.txt
> ===================================================================
> --- slub.orig/Documentation/vm/slub.txt	2007-05-23 19:34:49.000000000 -0700
> +++ slub/Documentation/vm/slub.txt	2007-05-23 19:59:45.000000000 -0700

> +Slab validation
> +---------------
> +
> +SLUB can validate all object if the kernel was booted with slub_debug. In
> +order to do so you must have the slabinfo tool. Then you can do
> +
> +slabinfo -v
> +
> +which will test all objects. Output will be generated to the syslog.
> +
> +This also works in a more limited way if boot was without slab debug.
> +In that case slabinfo -v simply tests all reachable objects. Usually
> +these are in the cpu slabs and the partial slabs. Full slabs are not

                    CPU

> +tracked by SLUB in a non debug situation.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
