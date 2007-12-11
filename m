Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbXLKA5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbXLKA5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 19:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbXLKA5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 19:57:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:64808 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbXLKA5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 19:57:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,149,1196668800"; 
   d="scan'208";a="240191184"
Subject: Re: [PATCH 1/4 -mm] kexec based hibernation -v7 : kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071210223117.GC27124@redhat.com>
References: <1197042810.24045.61.camel@caritas-dev.intel.com>
	 <20071210223117.GC27124@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 11 Dec 2007 08:55:45 +0000
Message-Id: <1197363345.24045.96.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 11 Dec 2007 00:56:03.0752 (UTC) FILETIME=[9ABDD280:01C83B90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-10 at 17:31 -0500, Vivek Goyal wrote:
> [..]
> >  
> > -#define KEXEC_ON_CRASH  0x00000001
> > -#define KEXEC_ARCH_MASK 0xffff0000
> > +#define KEXEC_ON_CRASH		0x00000001
> > +#define KEXEC_PRESERVE_CPU	0x00000002
> > +#define KEXEC_PRESERVE_CPU_EXT	0x00000004
> > +#define KEXEC_SINGLE_CPU	0x00000008
> > +#define KEXEC_PRESERVE_DEVICE	0x00000010
> > +#define KEXEC_PRESERVE_CONSOLE	0x00000020
> 
> Hi,
> 
> Why do we need so many different flags for preserving different types
> of state (CPU, CPU_EXT, Device, console) ? To keep things simple,
> can't we can create just one flag KEXEC_PRESERVE_CONTEXT, which will
> indicate any special action required for preserving the previous kernel's
> context so that one can swith back to old kernel?

Yes. There are too many flags, especially when we have no users of these
flags now. It is better to use one flag such as KEXEC_PRESERVE_CONTEXT
now, and create the others required flags when really needed.

Best Regards,
Huang Ying
