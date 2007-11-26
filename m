Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbXKZU4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbXKZU4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 15:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbXKZU4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 15:56:10 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40682 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754898AbXKZU4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 15:56:09 -0500
Date: Mon, 26 Nov 2007 12:56:08 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, kamalesh@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       balbir@linux.vnet.ibm.com, linux-acpi@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Subject: Re: 2.6.24-rc3-mm1 - Kernel Panic on IO-APIC
In-Reply-To: <20071126123319.7483e57f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711261254560.25688@schroedinger.engr.sgi.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
 <4743CC0B.9000508@linux.vnet.ibm.com> <20071120221839.faab108e.akpm@linux-foundation.org>
 <20071126143943.0a01665b@cuia.boston.redhat.com>
 <20071126123319.7483e57f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, Andrew Morton wrote:

> hm.  This smells like a startup ordering problem, but everything which
> refresh_zone_stat_thresholds() should be set up by the time we run
> initcalls.  Maybe the zone lists are bad?

refresh_zone_stat_thresholds goes through each zone and updates
the stat threshold for every per cpu structure in each zone.

So this could be a processor marked online where the pcp structures have 
not been allocated or a zone NULL pointer.

