Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbZBESCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbZBESCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759899AbZBESBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:01:47 -0500
Received: from kroah.org ([198.145.64.141]:56362 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759479AbZBESBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:01:46 -0500
Date: Thu, 5 Feb 2009 09:58:49 -0800
From: Greg KH <greg@kroah.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, gnb@sgi.com, gregkh@suse.de,
       nfsv4@linux-nfs.org, systemtap@sources.redhat.com
Subject: Re: [Patch 0/2] dynamic debug
Message-ID: <20090205175849.GA936@kroah.com>
References: <20090205164520.GB3114@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205164520.GB3114@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 11:45:20AM -0500, Jason Baron wrote:
> hi,
> 
> This patchset combines Greg Bank's dprintk() patchset with the dynamic printk
> patchset. We are renaming the combined solution 'dynamic debug'. As a reminder,
> the patchset allows debug printk style statements to be dynamically 
> enabled/disabled at runtime.
> 
> The key new feature of this patchset is a richer /debugfs control file
> interface, (an example output from my system is at the bottom), which allows
> fined grained control over the the debug output. The output can be controlled by
> function, file and line number, module, and format string. 

That's nice, but do we really need to have that kind of control?  It
seems like overkill.

> For example, to enable all debug statement in module 'nf_conntrack':
> 
> #echo -n 'module nf_conntrack +p' > /mnt/debugfs/dynamic_debug/control
> 
> A further explanation can be found in the documentation patch.
> 
> While adding these new features we have dropped a couple that we intend to add
> back in subsequent patches. The ability to turn on/off all debugging at once,
> either via the /debugfs control file, or via the kernel command line.
> 
> thanks,
> 
> -Jason and Greg
> 
> 
> # filename:lineno [module]function flags format
> arch/x86/kernel/setup_percpu.c:260 [setup_percpu]numa_set_node - "Setting\040node\040for\040non-present\040cpu\040%d\012"

Why the \040 syntax?  Can't we handle a space in a string?  Makes it
very hard to grep for things...

I'll give these a spin in my tree to see how it works for now.

thanks,

greg k-h
