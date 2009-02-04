Return-Path: <linux-kernel-owner+w=401wt.eu-S1760860AbZBDWcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbZBDWcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 17:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbZBDWcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 17:32:14 -0500
Received: from ns2.gothnet.se ([82.193.160.251]:4988 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753224AbZBDWcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 17:32:14 -0500
Message-ID: <498A1760.7010108@shipmail.org>
Date: Wed, 04 Feb 2009 23:32:00 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Gem GTT mmaps..
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse,

I have some concerns about the GEM GTT mmap functionality.

First, a gem object pointer is copied to map->offset and then to the 
vma->vm_private_data without proper reference counting. This pointer is 
used in i915_gem_fault() to access the gem object. However if the gem 
object is destroyed and a process then tries to access data in a vma 
mapping the (now destroyed) object, it would dereference a stale pointer 
into kernel space? Shouldn't those pointers be reference counted, and to 
account for fork(), a vm open and close would be needed to  reference 
count corresponding pointers of newly created and destroyed vmas?

Second, the i915_gem_fault method  returns VM_FAULT_SIGBUS if 
vm_insert_pfn() fails with an -EBUSY. I think that's an error, since 
that would indicate that the pte was already populated by a racing thread.

/Thomas




