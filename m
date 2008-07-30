Return-Path: <linux-kernel-owner+w=401wt.eu-S1761848AbYG3NgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761848AbYG3NgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 09:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbYG3Nft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 09:35:49 -0400
Received: from smarthost02.mail.zen.net.uk ([212.23.3.141]:36260 "EHLO
	smarthost02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbYG3Nfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 09:35:48 -0400
Date: Wed, 30 Jul 2008 14:35:29 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Miller <davem@davemloft.net>
Cc: tony.luck@intel.com, jgarzik@redhat.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, netdev@vger.kernel.org, matthew@wil.cx,
       holt@sgi.com, linux-net-drivers@solarflare.com
Subject: Re: [Patch] fix ia64 build failure when CONFIG_SFC=m
Message-ID: <20080730133527.GI10471@solarflare.com>
References: <20080729013650.GH9663@sgi.com> <57C9024A16AD2D4C97DC78E552063EA3080BA318@orsmsx505.amr.corp.intel.com> <20080729174839.GG10471@solarflare.com> <20080729.140040.72089155.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729.140040.72089155.davem@davemloft.net>
User-Agent: Mutt/1.4.1i
X-Originating-Smarthost02-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Ben Hutchings <bhutchings@solarflare.com>
> Date: Tue, 29 Jul 2008 18:48:41 +0100
> 
> > I think a single core in each package can generally saturate the
> > memory bus and this is why spreading the load wider is not useful.
> 
> I disagree, especially for routing and firewall setups.
> 
> You want as many cpu threads as possible, even on the same core,
> doing the routing and firewall lookups through the various
> datastructures, in parallel.

So far as I can see, hardly anyone is doing routing at 10G speeds on Linux.
If they were, the horrible interaction with LRO would presumably have been
found and fixed earlier.  Besides which, internal benchmarking showed that we
could route 1500-byte packets bidirectionally at very near line rate using one
core on each of two multi-core packages.  (I can give more details if you
want.)  The default can in any case be overridden using the rss_cpus module
parameter.  If you want to add a core network setting for that, I think we'd
be happy to use it.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.
