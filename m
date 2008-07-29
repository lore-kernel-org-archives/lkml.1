Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbYG2BXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbYG2BXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYG2BWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:22:51 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:46952 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbYG2BWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:22:50 -0400
Date: Tue, 29 Jul 2008 11:22:48 +1000
From: Simon Horman <horms@verge.net.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, Chandru <chandru@in.ibm.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Terry Loftin <terry.loftin@hp.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/5] Move elfcorehdr_addr out of vmcore.c (Was: Re:
	[patch] crashdump: fix undefined reference to `elfcorehdr_addr')
Message-ID: <20080729012245.GI10434@verge.net.au>
References: <20080727234529.GM6175@verge.net.au> <20080728015117.GA12055@verge.net.au> <20080728024526.GB3334@verge.net.au> <20080728034007.GA30450@verge.net.au> <20080728211025.GA9985@redhat.com> <m1vdypfwxe.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vdypfwxe.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 03:47:41PM -0700, Eric W. Biederman wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > Hi All,
> >
> > How does following series of patches look like. I have moved
> > elfcorehdr_addr out of vmcore.c and pushed it to arch dependent section 
> > of crash dump to make sure that it can be worked with even when
> > CONFIG_PROC_VMCORE is disabled and CONFIG_CRASH_DUMP is enabled.
> >
> > I tested it on x86_64. Compile tested it on i386 and ppc64. ia64 and
> > sh versions are completely untested.
> 
> Given the current state of the code:
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> To process a kernel crash dump we pass the kernel elfcorehdr option,
> so testing to see if it was passed seems reasonable.
> 
> In general I think this method of handling the problems with kdump is
> too brittle to live, but in the case of iommus we certainly need to do
> something different, and unfortunately iommus were not common on x86
> when the original code was merged so we have not handled them well.

Agreed, however these patches look like they really ought to be merged
into a single patch for the sake of bisect. As things stand, applying
the first patch will break the build on each architecture with an
architecture specific until the latter is applied.

-- 
Horms

