Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbYGJBvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbYGJBvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 21:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYGJBvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 21:51:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:46536 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYGJBvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 21:51:09 -0400
Date: Wed, 9 Jul 2008 18:50:55 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 02/34] AMD IOMMU: add header file for driver data
 structures and defines
Message-ID: <20080709185055.3b47c4db@infradead.org>
In-Reply-To: <20080709183823.52bbfd37.akpm@linux-foundation.org>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-3-git-send-email-joerg.roedel@amd.com>
	<20080709183823.52bbfd37.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2008 18:38:23 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 26 Jun 2008 21:27:38 +0200 Joerg Roedel
> <joerg.roedel@amd.com> wrote:
> 
> > +/* helper macros */
> > +#define LOW_U32(x) ((x) & ((1ULL << 32)-1))
> > +#define HIGH_U32(x) (LOW_U32((x) >> 32))
> 
> Please avoid putting general-purpose helpers into private header
> files.

especially broken helpers.

A >> 32 on something that may be a 32 bit entry is bad; int32 >> 32...
gcc can (and does!) optimize that out.

(because it first gets translated into a SHR x86 instruction which then
notices it's encoded as a zero shift.. which then gets deleted)



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
