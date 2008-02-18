Return-Path: <linux-kernel-owner+w=401wt.eu-S1761965AbYBRVDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761965AbYBRVDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756373AbYBRVDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:03:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbYBRVDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:03:07 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, andrew.grover@intel.com,
       paul.s.diefenbaugh@intel.com, linux@brodo.de,
       anil.s.keshavamurthy@intel.com, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: [PATCH 0/4] Avoid panic in case of buggy bios
Date: Mon, 18 Feb 2008 17:56:08 -0300
Message-Id: <1203368168-30257-1-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've came across a panic today after failing acpi_processor_start()
in this condition:

        if (processor_device_array[pr->id] != NULL &&
            processor_device_array[pr->id] != device) {
                printk(KERN_WARNING "BIOS reported wrong ACPI id "
                        "for the processor\n");
                return -ENODEV;
        }

The problem is that there are some data structures that are not initialized
if we exit that early, but the removal functions assume to be present. One
solution would be to move the checks to the bottom of this function, after
all the initializations are complete, but I personally think this is
not a good idea, from the waste point of view.

So I'm attaching a series of 4 patches that provides a criteria to decide
whether or not we got past the point of initializing that data structures,
and using it to conditionally unregister them latter.

Hope it's okay with you



