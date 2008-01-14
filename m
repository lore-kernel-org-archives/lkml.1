Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYANNax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYANNax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 08:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYANNag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 08:30:36 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:13118 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYANNae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 08:30:34 -0500
X-SBRS: None
X-MesageID: 37625956
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.24,282,1196658000"; 
   d="scan'208";a="37625956"
Subject: Re: [PATCH -mm 2/2] kexec/i386: kexec page table code clean up -
	page table setup in C
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Simon Horman <horms@verge.net.au>
Cc: "Huang, Ying" <ying.huang@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Magnus Damm <magnus.damn@gmail.com>
In-Reply-To: <20080110072117.GB26821@verge.net.au>
References: <1199847470.8126.16.camel@caritas-dev.intel.com>
	 <20080110010531.GA23143@redhat.com>
	 <1199930889.8752.7.camel@caritas-dev.intel.com>
	 <20080110072117.GB26821@verge.net.au>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Mon, 14 Jan 2008 13:29:49 +0000
Message-Id: <1200317389.11020.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 16:21 +0900, Simon Horman wrote: 
> [ CCing Ian Campbell who handles much of the maintenance of kexec in Xen ]
> 
> On Thu, Jan 10, 2008 at 10:08:09AM +0800, Huang, Ying wrote:
> > On Wed, 2008-01-09 at 20:05 -0500, Vivek Goyal wrote:
> > > On Wed, Jan 09, 2008 at 10:57:50AM +0800, Huang, Ying wrote:
> > > > This patch transforms the kexec page tables setup code from asseumbler
> > > > code to iC code in machine_kexec_prepare. This improves readability and
> > > > reduces code line number.
> > > > 
> > > 
> > > I think this will create issues for Xen. Initially page table setup
> > > was in C but Xen Guests could not modify the page tables. I think Xen
> > > folks implemented a hypercall where they passed all the page table pages
> > > and the control pages and then hypervisor executed the control page(which
> > > in turn setup the page tables). I think that's why page table setup
> > > code is on the control page in assembly.
> > > 
> > > You might want to go through Xen kexec implementation and dig through
> > > kexec mailing list archive.
> > 
> > OK, I will check the Xen kexec implementation.
> > 
> > > CCing Magnus and Horms. They had done the page tables related changes
> > > for Xen.
> 
> I think that potentially there is a problem here, though weather or
> not it manifests is another question.
> 
> In machine_kexec() a PAGE_SIZE blob of code starting at relocate_kernel
> gets saved. I think that previously x86 Linux excuded this saved blob,
> though the current code seems to execute relocate_kernel() directly -
> then again perhaps I'm confusing things with ia64 which still executes
> the saved blob.
> 
> In any case, in the case of xen, the hypervisor will execute this saved
> blob. So I think that the crux of the issue is that the blob contains
> all the instructions required to run relocate_kernel, then it should
> work from inside xen, if and if it doesn't, then i'll blow up.
> 
> The code that you have seems to satisfy this requirement,
> so relocate_kernel itself shouldn't be a problem. And as
> long as the preparation work does exacltly what the removed
> portions of relocate_kernel used to do, which it seems to,
> things should be fine.
> 
> That said, this certainly warrants testing :-)

In the absence of domain 0 or Xen kexec in the upstream kernel testing
might be quite hard.

> I'm all in favour of this kind of consolodation,
> so hopefully we can bend Xen's will if it doesn't work as is.

Indeed, patch seem reasonable to me. Whatever issues this causes for Xen
will be stuff that can be fixed once someone does the kexec for Xen work
in the upstream kernel, I don't think it paints us into an inescapable
corner.

Ian.


