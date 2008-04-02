Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbYDBSW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbYDBSW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756406AbYDBSWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:22:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181AbYDBSWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:22:19 -0400
Date: Wed, 2 Apr 2008 14:21:42 -0400
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca
Subject: Re: [patch 1/3] dynamic printk - core infrastructure
Message-ID: <20080402182128.GA15403@redhat.com>
References: <20080401194951.GC12029@redhat.com> <20080401144744.d0d10504.randy.dunlap@oracle.com> <1207102044.23161.163.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207102044.23161.163.camel@localhost>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 07:07:24PM -0700, Joe Perches wrote:
> On Tue, 2008-04-01 at 14:47 -0700, Randy Dunlap wrote:
> > > echo "add file.c" > /sys/kernel/debug/dynamic_printk/files
> > > echo "remove file.c" > /sys/kernel/debug/dynamic_printk/files
> 
> I think this would be better by module rather than filename.
> KBUILD_MODNAME would be a better choice.
> 
> 

agreed. i think 'KBUILD_MODNAME" provides a better interface. The original
implementation was using complete source pathnames, so they were unique. Are
'KBUILD_MODNAME's unique?

I was also thinking of expanding this beyond just 'printk'. ie add the ability 
to not only dynamically get printk output, but also tying more general 
statistics and debugging infrastructure into this. For example, 
CONFIG_SCHEDSTATS, can cause a runtime overhead. However, if we prefaced, the
calls with: if (unlikely(immediate_value)), we could drastically reduce the off
case. We might also need special cleanup and initialization functions, but I
could try and see what the code would look like.

-Jason 


