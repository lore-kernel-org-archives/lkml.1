Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbYEPCNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbYEPCNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 22:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYEPCNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 22:13:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:35918 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbYEPCNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 22:13:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,494,1204531200"; 
   d="scan'208";a="247633300"
Subject: Re: [PATCH] kexec based hibernation: a prototype of kexec
	multi-stage load
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080516020043.GC6926@redhat.com>
References: <1210574441.30365.8.camel@caritas-dev.intel.com>
	 <20080513053408.GA5870@redhat.com>
	 <1210730266.23707.50.camel@caritas-dev.intel.com>
	 <20080514025607.GA19944@redhat.com>
	 <1210736275.23707.62.camel@caritas-dev.intel.com>
	 <m1lk2c4l4i.fsf@frodo.ebiederm.org>
	 <1210827473.23707.133.camel@caritas-dev.intel.com>
	 <20080516020043.GC6926@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 16 May 2008 10:19:34 +0800
Message-ID: <1210904374.23707.178.camel@caritas-dev.intel.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 16 May 2008 02:13:04.0118 (UTC) FILETIME=[5F8C7960:01C8B6FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-15 at 22:00 -0400, Vivek Goyal wrote:
[...]
> IMHO, this kind of make more sense to me when keeping C function like
> semantics in mind.
> 
> Both the cases can be treated like calls to functions (calling BIOS function
> and jumping to kernel B). The basic difference between two cases is the
> re-entry point. In BIOS function case, we always re-enter the function at the
> start but in case of kernel B, except first entry, all other entries happen
> at a run time determined address, which needs to be communicated to kernel A.
> 
> I would think that second kernel B just should execute "ret" and new entry
> address of kernel B is passed to kernel A through %eax (return value of
> function).

The disadvantage of this solution is that kernel B must know it is
original kernel (A) or kexeced kernel (B). Different code should be used
by kernel A and kernel B. And after jump from A to B, jump from B to A,
when jump from A to B again, kernel A must use different code from the
first time.

Best Regards,
Huang Ying

