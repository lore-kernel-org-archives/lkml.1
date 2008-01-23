Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbYAWVDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbYAWVDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 16:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYAWVCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 16:02:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:13944 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbYAWVCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 16:02:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=B+Den6IOIBFv5tR62uWTaw8XcGUaQpM6wSt+ciW/gxV4/jstX7A7OkAgPWaPIH2nYP741tmnV6jIHogd2v5vg/HDDnY0Y0lhAkp0y05ggbzbXpNNyADIURwjCI97fj+hbHaofByzCcmtZlteWFltEmHamWGh7VSAy4a50QP5/0A=
Message-ID: <84144f020801231302g2cafdda9kf7f916121dc56aa5@mail.gmail.com>
Date: Wed, 23 Jan 2008 23:02:51 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nishanth Aravamudan" <nacc@us.ibm.com>
Subject: Re: [PATCH] Fix boot problem in situations where the boot CPU is running on a memoryless node
Cc: "Mel Gorman" <mel@csn.ul.ie>, akpm@linux-foundation.org,
       "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       lee.schermerhorn@hp.com, "Linux MM" <linux-mm@kvack.org>,
       "Olaf Hering" <olaf@aepfle.de>
In-Reply-To: <20080123195220.GB3848@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080123075821.GA17713@aepfle.de>
	 <20080123121459.GA18631@aepfle.de> <20080123125236.GA18876@aepfle.de>
	 <20080123135513.GA14175@csn.ul.ie>
	 <Pine.LNX.4.64.0801231611160.20050@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0801231626320.21475@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0801231648140.23343@sbz-30.cs.Helsinki.FI>
	 <20080123155655.GB20156@csn.ul.ie>
	 <Pine.LNX.4.64.0801231906520.1028@sbz-30.cs.Helsinki.FI>
	 <20080123195220.GB3848@us.ibm.com>
X-Google-Sender-Auth: c43647d5bd4eaf08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Jan 23, 2008 9:52 PM, Nishanth Aravamudan <nacc@us.ibm.com> wrote:
> On at least one of the machines in question, wasn't it the case that
> node 0 had all the memory and node 1 had all the CPUs? In that case, you
> would have to boot off a memoryless node? And as long as that is a
> physically valid configuration, the kernel should handle it.

Agreed. Here's the patch that should fix it:

http://lkml.org/lkml/2008/1/23/332

On Jan 23, 2008 9:52 PM, Nishanth Aravamudan <nacc@us.ibm.com> wrote:
> I bet we didn't notice this breaking because SLUB became the default and
> SLAB isn't on in the test.kernel.org testing, for instance. Perhaps we
> should add a second set of runs for some of the boxes there to run with
> CONFIG_SLAB on?

Sure.

On Jan 23, 2008 9:52 PM, Nishanth Aravamudan <nacc@us.ibm.com> wrote:
> I'm curious if we know, for sure, of a kernel with CONFIG_SLAB=y that
> has booted all of the boxes reporting issues? That is, did they all work
> with 2.6.23?

I think Mel said that their configuration did work with 2.6.23
although I also wonder how that's possible. AFAIK there has been some
changes in the page allocator that might explain this. That is, if
kmem_getpages() returned pages for memoryless node before, bootstrap
would have worked.

                           Pekka
