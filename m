Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbYKKGGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbYKKGGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 01:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYKKGG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 01:06:26 -0500
Received: from sh.osrg.net ([192.16.179.4]:37662 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbYKKGGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 01:06:25 -0500
Date: Tue, 11 Nov 2008 15:06:13 +0900
To: tony.luck@intel.com
Cc: fujita.tomonori@lab.ntt.co.jp, shehjart@cse.unsw.edu.au,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org
Subject: RE: Panic in multiple kernels: IA64 SBA IOMMU: Culprit commit on
 Mar 28, 2008
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA35C227994@orsmsx505.amr.corp.intel.com>
References: <49125F21.8010806@cse.unsw.edu.au>
	<20081107125011M.fujita.tomonori@lab.ntt.co.jp>
	<57C9024A16AD2D4C97DC78E552063EA35C227994@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081111150644Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008 08:58:28 -0800
"Luck, Tony" <tony.luck@intel.com> wrote:

> > Tony, changing the sba IOMMU driver to return an error instead of
> > panic in the case of allocation failure is fine with you?
> 
> This is fine ... but we do need to audit the callers to make
> sure that they check for and handle this new error.

Well, this is the issue discussed in the past several times...

The most of SCSI drivers are fine; they can handle IOMMU mapping
failure properly or panic. But there are some network drivers that
don't even check the failure. Fixing these network drivers has been on
my todo list... But as I said before, we ignore this problem; only
swiotlb and SBA panic in the case of IOMMU mapping failure.
