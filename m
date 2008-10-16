Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbYJPT0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbYJPT0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbYJPT0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:26:40 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:28361 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbYJPT0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:26:40 -0400
Subject: Re: [PATCH] disable CPU side GART accesses
From: Bob Montgomery <bob.montgomery@hp.com>
Reply-To: bob.montgomery@hp.com
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vojtech@suse.cz" <vojtech@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "chandru@in.ibm.com" <chandru@in.ibm.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <86802c440810161043k4c4bf6e6x4f5a70c54c53ca3b@mail.gmail.com>
References: <1224107317.2215.238.camel@amd.troyhebe>
	 <20081015234842.GA10999@elte.hu> <48F68940.40409@kernel.org>
	 <1224176445.2215.258.camel@amd.troyhebe>
	 <86802c440810161043k4c4bf6e6x4f5a70c54c53ca3b@mail.gmail.com>
Content-Type: text/plain
Organization: Contractor at HP
Date: Thu, 16 Oct 2008 13:26:48 -0600
Message-Id: <1224185208.2215.301.camel@amd.troyhebe>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-16 at 17:43 +0000, Yinghai Lu wrote:
> On Thu, Oct 16, 2008 at 10:00 AM, Bob Montgomery <bob.montgomery@hp.com> wrote:
> >
> > The problem occurs when the copy operation reads from the GART aperture
> > (iommu window) and wakes up the GART translation hardware.  This patch
> > stops that by telling the GART to ignore addresses that come from the
> > CPU and to only translate addresses from the IO side.
> 
> why kdump need to copy those area? those area is supposed to be
> reserved in e820 table by BIOS or first kernel.
> 
> YH

The crashdump analysis tools do not need a copy of this area.  But if a
user tool associated with the kdump operation manages to touch it
through /proc/vmcore or /dev/oldmem, it can crash the kdump kernel.
This seemed like a simple and logical way to prevent that danger.

Bob Montgomery

