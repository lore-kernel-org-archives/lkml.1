Return-Path: <linux-kernel-owner+w=401wt.eu-S1750757AbXCLR2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750757AbXCLR2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 13:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbXCLR2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 13:28:04 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55576 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbXCLR2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 13:28:02 -0400
Subject: Re: [RFC][PATCH 3/7] Data structures changes for RSS accounting
From: Dave Hansen <hansendc@us.ibm.com>
To: Pavel Emelianov <xemul@sw.ru>
Cc: Kirill Korotaev <dev@sw.ru>, "Eric W. Biederman" <ebiederm@xmission.com>,
       containers@lists.osdl.org, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45F58B91.4060001@sw.ru>
References: <45ED7DEC.7010403@sw.ru> <45ED8181.2060905@sw.ru>
	 <m18xe3wq3t.fsf@ebiederm.dsl.xmission.com>  <45F57CFB.9010707@sw.ru>
	 <1173718084.11945.51.camel@localhost.localdomain>  <45F58B91.4060001@sw.ru>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 10:27:51 -0700
Message-Id: <1173720471.11945.74.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 20:19 +0300, Pavel Emelianov wrote:
> Dave Hansen wrote:
> > On Mon, 2007-03-12 at 19:16 +0300, Kirill Korotaev wrote:
> >> now VE2 maps the same page. You can't determine whether this page is mapped
> >> to this container or another one w/o page->container pointer. 
> > 
> > Hi Kirill,
> > 
> > I thought we can always get from the page to the VMA.  rmap provides
> > this to us via page->mapping and the 'struct address_space' or anon_vma.
> > Do we agree on that?
> 
> Not completely. When page is unmapped from the *very last*
> user its *first* toucher may already be dead. So we'll never
> find out who it was.

OK, but  this is assuming that we didn't *un*account for the page when
the last user of the "owning" container stopped using the page.

> > We can also get from the vma to the mm very easily, via vma->vm_mm,
> > right?
> > 
> > We can also get from a task to the container quite easily.  
> > 
> > So, the only question becomes whether there is a 1:1 relationship
> > between mm_structs and containers.  Does each mm_struct belong to one
> 
> No. The question is "how to get a container that touched the
> page first" which is the same as "how to find mm_struct which
> touched the page first". Obviously there's no answer on this
> question unless we hold some direct page->container reference.
> This may be a hash, a direct on-page pointer, or mirrored
> array of pointers.

Or, you keep track of when the last user from the container goes away,
and you effectively account it to another one.

Are there problems with shifting ownership around like this?

-- Dave

