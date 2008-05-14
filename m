Return-Path: <linux-kernel-owner+w=401wt.eu-S1762387AbYENNJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762387AbYENNJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 09:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758247AbYENNJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 09:09:27 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56861 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbYENNJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 09:09:26 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 14 May 2008 18:39:04 +0530
Message-Id: <20080514130904.24440.23486.sendpatchset@localhost.localdomain>
Subject: [-mm][PATCH 0/4] Add memrlimit controller (v4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fourth version of the address space control patches. These
patches are against 2.6.26-rc2-mm1  and have been tested using KVM in SMP mode,
both with and without the config enabled, on a powerpc box and using UML.
The patches have also been compile tested with the config disabled on a
powerpc box.

The goal of this patch is to implement a virtual address space controller
using cgroups. The documentation describes the controller, it's goal and
usage in further details.

The first patch adds the user interface. The second patch fixes the
cgroup mm_owner_changed callback to pass the task struct, so that
accounting can be adjusted on owner changes. The thrid patch adds accounting
and control. The fourth patch updates documentation.

An earlier post of the patchset can be found at
http://lwn.net/Articles/275143/

This patch is built on top of the mm owner patches and utilizes that feature
to virtually group tasks by mm_struct.

Reviews, Comments?

Changelog

1. Add documentation upfront
2. Refactor the code (error handling and changes to improvde code)
3. Protect reading of total_vm with mmap_sem
4. Port to 2.6.26-rc2
5. Changed the name from rlimit to memrlimit

Series

memrlimit-controller-add-documentation.patch
memrlimit-controller-setup.patch
cgroup-add-task-to-mm-owner-callbacks.patch
memrlimit-controller-address-space-accounting-and-control.patch

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
