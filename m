Return-Path: <linux-kernel-owner+w=401wt.eu-S1757855AbZKCCEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbZKCCEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 21:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757000AbZKCCEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 21:04:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63664 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756642AbZKCCEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 21:04:40 -0500
Message-ID: <4AEF8F7E.1000007@cn.fujitsu.com>
Date: Tue, 03 Nov 2009 10:03:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: bblum@andrew.cmu.edu
CC: linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/3] cgroups: support for module-loadable subsystems
References: <20091102212825.GA13692@andrew.cmu.edu>
In-Reply-To: <20091102212825.GA13692@andrew.cmu.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Blum wrote:
> This patch series implements simple support for building and loading
> subsystems as modules, both within and outside the kernel source tree.
> Module unloading is as yet unimplemented - it will require more advanced
> reference counting in the mount/unmount code, and I plan to work on this
> soon.
> 

I doubt the value of module-loadable subsystems. A cgroup subsystem
is usually a kernel resource controller, and normally it needs to
add some hooks in some in-kernel structures and functions, which
makes it impossible to be a module.

In fact, net_cls is the only subsystem that can be a module, and
make it a module doesn't seem to have real benefit?

> Patch #1 sets up the subsys[] array so its contents can be dynamic as
> modules appear and (eventually) disappear. I introduce an rwsem called
> subsys_mutex to protect against concurrent loads/unloads/reads, and
> modify iterations over the array to handle when subsystems are absent.
> 
> Patch #2 implements an interface for modules to load subsystems, called
> cgroup_load_subsys, similar to cgroup_init_subsys, and adds a module
> pointer in struct cgroup_subsys.
> 
> Patch #3 modifies the net_cls subsystem, which already had some module
> declarations, to be configurable as a module, which also serves as a
> simple proof-of-concept.
> 
> -- bblum
>  
