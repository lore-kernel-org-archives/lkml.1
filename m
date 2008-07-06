Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbYGFObE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbYGFObE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 10:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbYGFOay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 10:30:54 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:8065 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbYGFOax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 10:30:53 -0400
Subject: Re: [PATCH] Make CONFIG_MIGRATION available for s390
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reply-To: gerald.schaefer@de.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, Dave Hansen <haveblue@us.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
In-Reply-To: <20080705150659.024F.E1E9C6FF@jp.fujitsu.com>
References: <1215183539.4834.12.camel@localhost.localdomain>
	 <20080705130203.e7df168c.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080705150659.024F.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain
Date: Sun, 06 Jul 2008 16:30:25 +0200
Message-Id: <1215354625.9842.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-05 at 15:14 +0900, Yasunori Goto wrote:
> > >  config MIGRATION
> > >  	bool "Page migration"
> > >  	def_bool y
> > > -	depends on NUMA
> > > +	depends on NUMA || S390
> 
> Hmm. I think ARCH_ENABLE_MEMORY_HOTREMOVE is better than S390.

Right, that makes more sense. I also noticed that my patch will produce
a compile error when CONFIG_NUMA is set but CONFIG_MIGRATION is not,
because policy_zone is missing in that case. Since policy_zone is only
used for NUMA, a better solution would be to use an "#ifdef CONFIG_NUMA"
within vma_migratable(). I will send a new version of the patch.

Thanks,
Gerald


