Return-Path: <linux-kernel-owner+w=401wt.eu-S1751419AbZDXLVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419AbZDXLVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 07:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZDXLVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 07:21:00 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:34760 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZDXLVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:21:00 -0400
Message-ID: <49F1A064.6040100@csr.com>
Date: Fri, 24 Apr 2009 12:20:04 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: dma_debug_device_change() gives bogus errors
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2009 11:20:04.0997 (UTC) FILETIME=[9E016B50:01C9C4CE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_debug_device_change() gives bogus errors if a driver unmaps dma
buffers within its driver->remove() method.  This is because the
BUS_NOTIFY_UNBIND_DRIVER notification is raised before calling
driver->remove() (see __device_release_driver() in drivers/base/dd.c).

By the time my driver->remove() completes, there are no DMA mappings
(debug_dma_dump_mappings() produces no output).

Also, somewhat surprisingly, it only prints the error the first time the
driver is unbound.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
