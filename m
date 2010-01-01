Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092Ab0AATv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab0AATv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 14:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993Ab0AATv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 14:51:28 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:53135 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab0AATv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 14:51:27 -0500
Message-ID: <4B3E51FC.9000502@xenontk.org>
Date: Sat, 02 Jan 2010 01:20:20 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.5) Gecko/20091209 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: andreas.herrmann3@amd.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Regression] 2.6.33-rc2 - pci: Commit e0cd516 causes OOPS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Commit e0cd516 causes an null pointer dereference when reading from the
sysfs attributes local_cpu* on Intel machines with no ACPI NUMA
proximity info, since dev->numa_node gets set to -1 for all PCI devices,
which then gets passed to cpumask_of_node.

The patch following this mail fixes the problem for x86. Perhaps a more
thorough solution would be to fix the PCI layer to set the node
information for devices to zero rather than -1 (Since if CONFIG_NUMA=y
we have node 0)? I don't know whether it is safe / correct to do this.

Regards,
David.
