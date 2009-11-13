Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbZKMLfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbZKMLfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 06:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbZKMLfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 06:35:43 -0500
Received: from smtp.nokia.com ([192.100.122.230]:25660 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbZKMLfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 06:35:42 -0500
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Matt Mackall <mpm@selenic.com>
Cc: David VomLehn <dvomlehn@cisco.com>, linux-embedded@vger.kernel.org,
       akpm@linux-foundation.org, dwm2@infradead.org,
       linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com
In-Reply-To: <1258049211.10621.40.camel@calx>
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
	 <1258049211.10621.40.camel@calx>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 13:35:03 +0200
Message-Id: <1258112103.21596.1217.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Nov 2009 11:35:08.0190 (UTC) FILETIME=[5A34FBE0:01CA6455]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 12:06 -0600, Matt Mackall wrote:
> On Wed, 2009-11-11 at 21:13 -0500, David VomLehn wrote:
> > Allows annotation of panics to include platform information. It's no big
> > deal to collect information, but way helpful when you are collecting
> > failure reports from a eventual base of millions of systems deployed in
> > other people's homes.
> 
> I'd like to hear a bit more use case motivation on this feature. Also,
> why do you want more than a page?

We also need this kind of functionality. The use case is very simple.
Every time the kernel oopeses, we save the oops information on the flash
using mtdoops module. There is even core support, which should be merged
to 2.6.33, see this patch:

http://git.infradead.org/users/dedekind/l2-mtd-2.6.git/commit/832c3d00e82f267316a2b53634631a1821eebae8

(and there was a corresponding discussion on lkml).

And what we want is to dump information about the user-space environment
at the same time to the oops. Specifically, we want to dump information
about what was the SW build number.

And we want this information to be printed at the same time, because we
cannot run any user-space at the panic time. This information is later
read from the flash and sent via the network to the central place. And
by the time it is sent, the user may have already re-flashed his device
with something else.

So I very much appreciate this patch, although I think it should use the
panic notifiers instead of calling a function directly from the panic.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

