Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbYDBS7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbYDBS7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756304AbYDBS7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:59:34 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4824 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbYDBS7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:59:33 -0400
Subject: Re: [patch 1/3] dynamic printk - core infrastructure
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca
In-Reply-To: <20080402182128.GA15403@redhat.com>
References: <20080401194951.GC12029@redhat.com>
	 <20080401144744.d0d10504.randy.dunlap@oracle.com>
	 <1207102044.23161.163.camel@localhost>  <20080402182128.GA15403@redhat.com>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 11:58:05 -0700
Message-Id: <1207162685.23161.217.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 14:21 -0400, Jason Baron wrote:
> On Tue, Apr 01, 2008 at 07:07:24PM -0700, Joe Perches wrote:
> > On Tue, 2008-04-01 at 14:47 -0700, Randy Dunlap wrote:
> > > > echo "add file.c" > /sys/kernel/debug/dynamic_printk/files
> > > > echo "remove file.c" > /sys/kernel/debug/dynamic_printk/files
> > I think this would be better by module rather than filename.
> > KBUILD_MODNAME would be a better choice.
> agreed. i think 'KBUILD_MODNAME" provides a better interface. The original
> implementation was using complete source pathnames, so they were unique. Are
> 'KBUILD_MODNAME's unique?

Yes, not by file, but by groups of compilation units
that make up a module.  I think that's more sensible anyway.

I also have patches to pr_<level> that allow for dynamic
prefixing of KBUILD_MODNAME, __FUNCTION__, and __LINE__ 
that might be a useful addition to a facility such as yours.

These patches also make the kernel smaller by removing the
direct uses of __FILE__/__FUNCTION__/__func__ from pr_<level>.

I intend to post them during the next merge window.

