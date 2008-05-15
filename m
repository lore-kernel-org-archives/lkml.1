Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbYEOCeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbYEOCeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 22:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbYEOCe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 22:34:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:46844 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbYEOCeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 22:34:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,489,1204531200"; 
   d="scan'208";a="328418770"
Subject: Re: [PATCH] kexec based hibernation: a prototype of kexec
	multi-stage load
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <m1lk2c4l4i.fsf@frodo.ebiederm.org>
References: <1210574441.30365.8.camel@caritas-dev.intel.com>
	 <20080513053408.GA5870@redhat.com>
	 <1210730266.23707.50.camel@caritas-dev.intel.com>
	 <20080514025607.GA19944@redhat.com>
	 <1210736275.23707.62.camel@caritas-dev.intel.com>
	 <m1lk2c4l4i.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 15 May 2008 10:40:07 +0800
Message-ID: <1210819207.23707.107.camel@caritas-dev.intel.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 15 May 2008 02:33:42.0014 (UTC) FILETIME=[16FAA9E0:01C8B634]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-14 at 14:43 -0700, Eric W. Biederman wrote:
> "Huang, Ying" <ying.huang@intel.com> writes:
> 
> >> So, IMHO, for first simple implementation, we don't have to pass around
> >> any data between kernels except entry point. (Please correct me if I am 
> >> wrong). Lets get that implementation in first and then we can get rest
> >> of the pieces in place.
> >
> > Yes. Kernel entry/re-entry point is the only information need to be
> > communicated between kernels for just switching between them. So we can
> > focus on kexec jump patch firstly.
> 
> Then as a preliminary design let's plan on this.
> 
> - Pass the rentry point as the return address (using the C ABI).
>   We may want to load the stack pointer etc so we can act as
>   a direct entry point for new code.

OK, I will try to do this.

> - Look at passing a pointer to the mapping of pages that the kexec
>   trampoline uses in arg1 of the C ABI.  Largely the format is defacto
>   fixed anyway because we need to pass the structure from C to
>   assembly.

You mean pass image->head to purgatory of /sbin/kexec using arg1 of C
ABI?

> Using the standard C ABI makes things much it much easier to pick
> a calling convention, and to document it.

Yes.

Best Regards,
Huang Ying

