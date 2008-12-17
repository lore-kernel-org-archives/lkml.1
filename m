Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759400AbYLQIrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbYLQIrh (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 03:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbYLQIr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 03:47:26 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:27915 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYLQIr0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 03:47:26 -0500
Message-Id: <4948CAC3.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 17 Dec 2008 08:47:47 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Cc: <joerg.roedel@amd.com>, <ian.campbell@citrix.com>, <mingo@elte.hu>,
        <jeremy@goop.org>, <x86@kernel.org>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00 of 14] swiotlb/x86: lay groundwork for xen dom0
	 useof swiotlb
References: <patchbomb.1229458644@abulafia.goop.org>
 <20081216203513.GA14787@elte.hu>
 <20081217142637V.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081217142637V.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>I think that the whole patchset is against the swiotlb design. swiotlb
>is designed to be used as a library. Each architecture implements the
>own swiotlb by using swiotlb library
>(e.g. arch/x86/kernel/pci-swiotlb_64.c).

If it is a library, then it should be prepared to serve all possible users.

>For example, adding the following code (9/14) for just Xen that the
>majority of swiotbl users (x86_64 and IA64) don't need to the library
>is against the design.

"Don't" in terms of "currently don't": Once x86-64 wants to support more
than 46 physical address bits, it's not impossible that this would lead to
CONFIG_HIGHMEM getting introduced there, and then it'll be helpful that the
code is already prepared to deal with that case.

After all, the code portion in question ought to compile to nothing if
!CONFIG_HIGHMEM.

Jan

