Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944Ab0ADE2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab0ADE2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 23:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834Ab0ADE2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 23:28:38 -0500
Received: from ozlabs.org ([203.10.76.45]:56874 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab0ADE2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 23:28:38 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: David John <davidjon@xenontk.org>
Subject: Re: [PATCH v2] Check the node argument passed to cpumask_of_node
Date: Mon, 4 Jan 2010 14:58:22 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: jbarnes@virtuousgeek.org, andreas.herrmann3@amd.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org
References: <201001012255.28094.rjw@sisk.pl> <1262412947-3890-1-BlackWidow-davidjon@xenontk.org>
In-Reply-To: <1262412947-3890-1-BlackWidow-davidjon@xenontk.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001041458.24145.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jan 2010 04:45:47 pm David John wrote:
> Commit e0cd516 "PCI: derive nearby CPUs from device's instead of bus' NUMA information"
> causes an null pointer dereference when reading from the sysfs attributes local_cpu*
> on Intel machines with no ACPI NUMA proximity info, since dev->numa_node gets set to -1
> for all PCI devices, which then gets passed to cpumask_of_node.
> 
> Ensure that the node value is valid.

This only works for x86, and only for !CONFIG_DEBUG_PER_CPU_MAPS.

I suggest fixing the callers introduced in e0cd516 for the moment,
then if you feel enthused, change the semantics of cpumask_of_node and
remove the checks from the various callers.

(And please only check for -1: it has a special meaning, unlike other
invalid numbers which indicate a bug).

Thanks,
Rusty.
