Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbZHCXSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbZHCXSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 19:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZHCXSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 19:18:35 -0400
Received: from ozlabs.org ([203.10.76.45]:38879 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbZHCXSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 19:18:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: linux-next: rr tree build failure
Date: Tue, 4 Aug 2009 08:48:26 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
References: <20090803133203.81174a8e.sfr@canb.auug.org.au> <200908031422.28171.bjorn.helgaas@hp.com>
In-Reply-To: <200908031422.28171.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908040848.27364.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Aug 2009 05:52:27 am Bjorn Helgaas wrote:
> On Sunday 02 August 2009 09:32:03 pm Stephen Rothwell wrote:
> > Hi Rusty,
> > 
> > Today's linux-next build (x86_64 allmodconfig) failed like this:
> > 
> > drivers/acpi/osl.c: In function 'bind_to_cpu0':
> > drivers/acpi/osl.c:194: error: implicit declaration of function 'set_cpus_allowed'
> > 
> > Caused by commit 74b5820808215f65b70b05a099d6d3c969b82689 ("ACPI: bind
> > workqueues to CPU 0 to avoid SMI corruption") (from the acpi tree but now
> > in Linus' tree) interacting with commit
> > 17e249fb40c814a72f08c1356cb47ec9f87f81a8
> > ("cpumask:remove-set_cpus_allowed") from the rr tree.
> > 
> > I have reverted that rr tree commit for today.
> 
> Here's a patch to fix this.  Since Linus' tree still contains instances
> of set_cpus_allowed(), I'm guessing this patch should be added to the rr
> tree?
> 
> Bjorn

Yep, my series removes it, at least for CONFIG_CPUMASK_OFFSTACK=y.

Thanks!
Rusty.
