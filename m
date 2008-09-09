Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbYIIPMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbYIIPMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYIIPMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:12:47 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52343 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbYIIPMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:12:47 -0400
Subject: Re: [PATCH] Cleanup to make  remove_memory() arch neutral
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, garyhade@us.ibm.com,
       linux-mm@kvack.org, mel@csn.ul.ie, lcm@us.ibm.com,
       linux-kernel@vger.kernel.org, x86@kernel.org, mingo@elte.hu
In-Reply-To: <20080909101703.C099.E1E9C6FF@jp.fujitsu.com>
References: <1220910754.25932.57.camel@badari-desktop>
	 <20080908175621.6dfad0a6.akpm@linux-foundation.org>
	 <20080909101703.C099.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain
Date: Tue, 09 Sep 2008 08:12:52 -0700
Message-Id: <1220973172.25932.68.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-09-09 at 10:21 +0900, Yasunori Goto wrote:
> > On Mon, 08 Sep 2008 14:52:34 -0700
> > Badari Pulavarty <pbadari@us.ibm.com> wrote:
> > 
> > > There is nothing architecture specific about remove_memory().
> > > remove_memory() function is common for all architectures which
> > > support hotplug memory remove. Instead of duplicating it in every
> > > architecture, collapse them into arch neutral function.
> > > 
> > > Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> > > 
> > >  arch/ia64/mm/init.c   |   17 -----------------
> > >  arch/powerpc/mm/mem.c |   17 -----------------
> > >  arch/s390/mm/init.c   |   11 -----------
> > >  mm/memory_hotplug.c   |   10 ++++++++++
> > >  4 files changed, 10 insertions(+), 45 deletions(-)
> > 
> > I spent some time trying to build-test this on ia64 and gave up.  How
> > the heck do you turn on memory hotplug on ia64?
> > 
> 
> EXPORT_SYMBOL_GPL(remove_memory) is removed.
> It is required by drivers/acpi/acpi_memhotplug.ko.

Thanks for catching it. I forgot that it was being used
by acpi. Since we didn't export it for ppc and s390,
I assumed its safe to remove the export. Sorry !!

Thanks,
Badari

