Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbYDCUYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbYDCUYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 16:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYDCUYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 16:24:15 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:34391 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbYDCUYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 16:24:14 -0400
Date: Thu, 3 Apr 2008 21:22:10 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, David Rientjes <rientjes@google.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: cgroup_disable=memory for 2.6.25?
Message-ID: <Pine.LNX.4.64.0804032055590.8157@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir,

I'm rather surprised that nobody has pushed -mm's

cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time-fix-boot-option-parsing.patch
memory-controller-make-memory-resource-control-aware-of-boot-options.patch

into 2.6.25: which was what I'd expected when I first suggested that
distros might want a way to build with the potential for mem cgroups,
but be able to switch off their significant overhead for everyone not
interested.

Ballpark figures, I'm trying to get this question out rather than
processing the exact numbers: CONFIG_CGROUP_MEM_RES_CTLR adds 15%
overhead to the affected paths, booting with cgroup_disable=memory
cuts that back to 1% overhead (due to slightly bigger struct page).

I'm no expert on distros, they may have no interest whatever in
CONFIG_CGROUP_MEM_RES_CTLR=y; and the rest of us can easily build
with or without it, or apply the cgroup_disable=memory patches.

But if those patches serve a purpose, shouldn't they be in 2.6.25?

Hugh
