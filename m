Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbXL1Hdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbXL1Hdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 02:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbXL1Hd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 02:33:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:39364 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbXL1Hd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 02:33:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,215,1196668800"; 
   d="scan'208";a="466825184"
Subject: Re: [PATCH 0/3 -mm] kexec jump -v8
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071227181218.GA15084@redhat.com>
References: <1198222399.1965.15.camel@caritas-dev.intel.com>
	 <20071227015716.GA6718@redhat.com>
	 <1198722793.7320.15.camel@caritas-dev.intel.com>
	 <20071227181218.GA15084@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Dec 2007 15:30:53 +0800
Message-Id: <1198827053.7320.33.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 28 Dec 2007 07:30:33.0072 (UTC) FILETIME=[87C72F00:01C84923]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-27 at 13:12 -0500, Vivek Goyal wrote:
> On Thu, Dec 27, 2007 at 10:33:13AM +0800, Huang, Ying wrote:
> > On Wed, 2007-12-26 at 20:57 -0500, Vivek Goyal wrote:
> > [...]
> > > > 9. Now, you are in the original kernel again. You can read/write the
> > > >    memory image of kexeced kernel via /proc/kimgcore.
> > > > 
> > > 
> > > Why do we need two interfaces, /proc/vmcore and /proc/kimgcore? Can't
> > > we have just one say /proc/vmcore. Irrespective of what kernel you are
> > > in /proc/vmcore gives you the access to the memory of kernel which was
> > > previously booted.
> > 
> > In theory we can kexec another kernel even in a kexeced kernel, that is,
> > in kernel A kexec kernel B, and in kernel B kexec another kernel C. In
> > this situation, both /proc/vmcore and /proc/kimgcore has valid contents.
> > So I think, it may be better to keep two interfaces.
> > 
> 
> In those situations I think only one interface is better. For example, 
> above will be broken if somebody kexec 4 kernels.
> 
> A-->B--->C--->D

I don't think the two interfaces will be broken if somebody kexec 4
kernels. For example, when kexec D from C, the /proc/vmcore is contents
of B, /proc/kimgcore is contents of D. To jump back from C to B, the D
is unloaded, and a jump back helper image is loaded.

> I think better option might be if it is stack like situation. A kernel
> shows you only the previous kernel's memory contents through /proc/vmcore
> interface. So If I am in kernel D, I see only kernel C's memory image.
> To see kernel B's memory image, one shall have to go back to kernel C.

Maybe it is not sufficient to only show the previous kernel's memory
contents. In kernel C, you maybe need to access the memory image of
kernel B and memory image of kernel D.

That is, /proc/vmcore is the memory image of the previous kernel,
and /proc/kimgcore is the memory image of the next kernel.

Best Regards,
Huang Ying

