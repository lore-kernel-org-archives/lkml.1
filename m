Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbYDDSfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbYDDSfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 14:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbYDDSfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 14:35:01 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3565 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbYDDSfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 14:35:00 -0400
Subject: Re: [patch 1/3] dynamic printk - core infrastructure
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       mathieu.desnoyers@polymtl.ca
In-Reply-To: <20080404181308.GA14160@redhat.com>
References: <20080401194951.GC12029@redhat.com>
	 <20080401144744.d0d10504.randy.dunlap@oracle.com>
	 <1207102044.23161.163.camel@localhost> <20080402182128.GA15403@redhat.com>
	 <1207162685.23161.217.camel@localhost>  <20080404181308.GA14160@redhat.com>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 11:33:46 -0700
Message-Id: <1207334026.23161.385.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-04 at 14:13 -0400, Jason Baron wrote:
> here is a re-spun patch incorporating comments from the thread.

> +#define dev_dbg(dev, format, arg...) do {				    \
> +	if (unlikely(imv_read(dynamic_debug_on)))			    \

I think the use of unlikely here and in pr_debug is unnecessary.

> +static struct hlist_head file_table[FILE_TABLE_SIZE] =
> +	{ [0 ... FILE_TABLE_SIZE-1] = HLIST_HEAD_INIT };
> +static DECLARE_MUTEX(debug_list_mutex);
> +static int nr_entries;

Shouldn't this be a module_table?

I think that hashing may be an unnecessary optimization and
that there's no real need to use a limited FILE_TABLE_SIZE
at all.  I think the most likely use cases for this facility
has either one or two modules being debugged or all modules
or no modules.

cheers, Joe

