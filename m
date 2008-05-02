Return-Path: <linux-kernel-owner+w=401wt.eu-S935307AbYEBN5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935307AbYEBN5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935204AbYEBN4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:56:49 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:61463 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935190AbYEBN4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:56:48 -0400
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns;
  h=X-IronPort-AV:Date:From:To:Cc:Subject:Message-ID:
   References:Mime-Version:Content-Type:Content-Disposition:
   In-Reply-To:User-Agent;
  b=HBsEs5/ZTC6wBIVSxXU/lbLeDZDGBhbqN+6aMNEWup8IfOMzY0KtX7un
   Xc1pMZW7HQkwRtzUDT0F3KSgZiM9VZShZJnxNahnCId0gJddDs/tU76Jo
   7xZuJM5cLpUSjbW;
X-IronPort-AV: E=Sophos;i="4.27,426,1204524000"; 
   d="scan'208";a="34938171"
Date: Fri, 2 May 2008 08:56:30 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, jgarzik@pobox.com, muli@il.ibm.com,
       davej@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       bunk@kernel.org, linux-bugs@dell.com, linux-kernel@vger.kernel.org,
       greg@kroah.com, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Michal Schmidt <mschmidt@redhat.com>, andy@greyhouse.net,
       john.cagle@hp.com
Subject: Re: [PATCH] fix x86 DMI checks for PCI quirks
Message-ID: <20080502135630.GB15645@auslistsprd01.us.dell.com>
References: <20080502025427.GA23757@auslistsprd01.us.dell.com> <20080502074432.GA1372@elte.hu> <86802c440805020219t73a8ae52ue7b15cfa36ac64de@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440805020219t73a8ae52ue7b15cfa36ac64de@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 02:19:34AM -0700, Yinghai Lu wrote:
> On Fri, May 2, 2008 at 12:44 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >  * Matt Domsch <Matt_Domsch@dell.com> wrote:
> >
> >  > fix x86 DMI checks for PCI quirks
> >  >
> >  > http://bugzilla.kernel.org/show_bug.cgi?id=10583
> >  > https://bugzilla.redhat.com/show_bug.cgi?id=444791
> >  >
> >  > Since git commit 08f1c192c3c32797068bfe97738babb3295bbf42 (between
> >  > kernels 2.6.22 and 2.6.23), arch/x86/pci/acpi.c has not called
> >  > pcibios_scan_root(), which would have called
> >  > arch/x86/pci/common.c:dmi_check_system().  This has prevented the
> >  > quirks listed in pciprobe_dmi_table[] from being checked and
> >  > appropriate action taken.
> >
> >  ugh ...
> >
> >
> >  > This manifests itself in several Dell and HP servers not automatically
> >  > having the pci=bfsort option be applied, as well as Samsung X20 and
> >  > Compaq EVO N800c systems needing pci=assign-all-busses was no longer
> >  > automatically applied.
> >
> >  Jesse Barnes (new PCI maintainer) Cc:-ed.
> 
> please check the patch in x86.git, it should do the same thing, but
> put the call in pci_access_init...
> 
> commit 9817aa147000086bc11b571620ecc1c73a4a614b
> Author: Yinghai Lu <yhlu.kernel@gmail.com>
> Date:   Mon Apr 14 15:40:37 2008 -0700

Indeed it does (boot tested on one of the affected systems), and is a
simpler patch.  I'd be quite happy with this.  Bonus that it's already
in the x86.git tree. :-)

Ingo, is this ready to go to Linus?

Now to get it backported to -stable...

Adding the folks from HP who have lots of systems listed.

Thanks,
Matt

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
