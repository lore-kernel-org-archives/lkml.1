Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbXKFRQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbXKFRQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 12:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbXKFRQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 12:16:05 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:54254 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbXKFRQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 12:16:04 -0500
Message-ID: <4730A15A.6070001@us.ibm.com>
Date: Tue, 06 Nov 2007 11:16:10 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Avi Kivity <avi@qumranet.com>, Dor Laor <dor.laor@qumranet.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Use of virtio device IDs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

I've written a PCI virtio transport and noticed something strange.  All 
current in-tree virtio devices register ID tables that match a specific 
device ID, but any vendor ID.

This is incompatible with using PCI vendor/device IDs for virtio 
vendor/device IDs since vendors control what device IDs mean.  A simple 
solution would be to assign a fixed vendor ID to all current virtio 
devices.  This doesn't solve the problem completely though since you 
would create a conflict between the PCI vendor ID space and the virtio 
vendor ID space.

The only solutions seem to be virtualizing the virtio vendor/device IDs 
(which is what I'm currently doing) or to mandate that the virtio vendor 
ID be within the PCI vendor ID space.  It's probably not necessary to 
make the same requirement for device IDs though.

What are your thoughts?

Regards,

Anthony Liguori
