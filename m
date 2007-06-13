Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbXFMQUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbXFMQUD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 12:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758361AbXFMQTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 12:19:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758074AbXFMQTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 12:19:54 -0400
Date: Wed, 13 Jun 2007 12:19:31 -0400
From: Dave Jones <davej@redhat.com>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       stin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-ID: <20070613161931.GF3875@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bodo Eggert <7eggert@gmx.de>, Jesse Barnes <jesse.barnes@intel.com>,
	linux-kernel@vger.kernel.org, stin Piszcz <jpiszcz@lucidpixels.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>
References: <8tyOc-8f0-17@gated-at.bofh.it> <E1HyMiN-0000oB-TR@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HyMiN-0000oB-TR@be1.lrz>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 08:52:23AM +0200, Bodo Eggert wrote:
 > Jesse Barnes <jesse.barnes@intel.com> wrote:
 > 
 > > On some machines, buggy BIOSes don't properly setup WB MTRRs to
 > > cover all available RAM, meaning the last few megs (or even gigs)
 > > of memory will be marked uncached.  Since Linux tends to allocate
 > > from high memory addresses first, this causes the machine to be
 > > unusably slow as soon as the kernel starts really using memory
 > > (i.e. right around init time).
 > > 
 > > This patch works around the problem by scanning the MTRRs at
 > > boot and figuring out whether the current end_pfn value (setup
 > > by early e820 code) goes beyond the highest WB MTRR range, and
 > > if so, trimming it to match.  A fairly obnoxious KERN_WARNING
 > > is printed too, letting the user know that not all of their
 > > memory is available due to a likely BIOS bug.
 > 
 > Wouldn't it be better to correct the MTRR, if possible? As far as I read
 > here (LKML), the BIOS did not merge the entries

The size/alignment constraints of MTRRs (must be a power of 2)
means that the best-fit method of covering non power of 2 memory sizes
is the, well.. best fit.  There's nothing that can be merged.

	Dave

-- 
http://www.codemonkey.org.uk
