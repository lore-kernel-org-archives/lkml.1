Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZKBVmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZKBVmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 16:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbZKBVmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 16:42:17 -0500
Received: from RELAY.ANDREW.CMU.EDU ([128.2.10.212]:58711 "EHLO
	relay.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815AbZKBVly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 16:41:54 -0500
Date: Mon, 2 Nov 2009 16:28:26 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       lizf@cn.fujistu.com, akpm@linux-foundation.org, menage@google.com,
       bblum@andrew.cmu.edu
Subject: [RFC][PATCH 0/3] cgroups: support for module-loadable subsystems
Message-ID: <20091102212825.GA13692@andrew.cmu.edu>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	containers@lists.linux-foundation.org, lizf@cn.fujistu.com,
	akpm@linux-foundation.org, menage@google.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements simple support for building and loading
subsystems as modules, both within and outside the kernel source tree.
Module unloading is as yet unimplemented - it will require more advanced
reference counting in the mount/unmount code, and I plan to work on this
soon.

Patch #1 sets up the subsys[] array so its contents can be dynamic as
modules appear and (eventually) disappear. I introduce an rwsem called
subsys_mutex to protect against concurrent loads/unloads/reads, and
modify iterations over the array to handle when subsystems are absent.

Patch #2 implements an interface for modules to load subsystems, called
cgroup_load_subsys, similar to cgroup_init_subsys, and adds a module
pointer in struct cgroup_subsys.

Patch #3 modifies the net_cls subsystem, which already had some module
declarations, to be configurable as a module, which also serves as a
simple proof-of-concept.

-- bblum
 
