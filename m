Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbYLWQXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbYLWQXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbYLWQXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:23:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45932 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYLWQXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:23:15 -0500
Date: Tue, 23 Dec 2008 11:22:29 -0500
From: Jason Baron <jbaron@redhat.com>
To: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: dynamic_printk documentation
Message-ID: <20081223162229.GB4126@redhat.com>
References: <4950D8B5.5040404@phoenixsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4950D8B5.5040404@phoenixsoftware.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 01:25:25PM +0100, Tilman Schmidt wrote:
> Where is the current debugfs interface to dynamic_printk documented?
> From the source in lib/dynamic_printk.c I deduced that
> 
> echo "set enable=1 <module_name>" > /sys/kernel/debug/dynamic_printk/modules
> 
> should enable debug output for module <module_name>, and verified
> experimentally that this does indeed work. Is that already described
> somewhere I just overlooked? If not, I would propose creating a file
> Documentation/dynamic_printk.txt.
> 
> Thanks,
> Tilman

hi,

Most of it is with the config parameter definition in lib/Kconfig.debug
(copied below). I can propose copying it into Documentation/ if you think it'd 
be useful.

thanks,

-Jason


config DYNAMIC_PRINTK_DEBUG
	bool "Enable dynamic printk() call support"
	default n
	depends on PRINTK
	select PRINTK_DEBUG
	help

	  Compiles debug level messages into the kernel, which would not
	  otherwise be available at runtime. These messages can then be
	  enabled/disabled on a per module basis. This mechanism implicitly
	  enables all pr_debug() and dev_dbg() calls. The impact of this
	  compile option is a larger kernel text size of about 2%.

	  Usage:

	  Dynamic debugging is controlled by the debugfs file,
	  dynamic_printk/modules. This file contains a list of the modules that
	  can be enabled. The format of the file is the module name, followed
	  by a set of flags that can be enabled. The first flag is always the
	  'enabled' flag. For example:

		<module_name> <enabled=0/1>
				.
				.
				.

	  <module_name> : Name of the module in which the debug call resides
	  <enabled=0/1> : whether the messages are enabled or not

	  From a live system:

		snd_hda_intel enabled=0
		fixup enabled=0
		driver enabled=0

	  Enable a module:

	  	$echo "set enabled=1 <module_name>" > dynamic_printk/modules

	  Disable a module:

	  	$echo "set enabled=0 <module_name>" > dynamic_printk/modules

	  Enable all modules:

		$echo "set enabled=1 all" > dynamic_printk/modules

	  Disable all modules:

		$echo "set enabled=0 all" > dynamic_printk/modules

	  Finally, passing "dynamic_printk" at the command line enables
	  debugging for all modules. This mode can be turned off via the above
	  disable command.

