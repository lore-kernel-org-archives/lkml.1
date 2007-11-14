Return-Path: <linux-kernel-owner+w=401wt.eu-S1757697AbXKNLph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697AbXKNLph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbXKNLp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:45:29 -0500
Received: from ozlabs.org ([203.10.76.45]:47787 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbXKNLp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:45:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18234.57272.590960.860941@cargo.ozlabs.ibm.com>
Date: Wed, 14 Nov 2007 22:44:56 +1100
From: Paul Mackerras <paulus@samba.org>
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de,
       mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
In-Reply-To: <20071114.031216.11725447.davem@davemloft.net>
References: <20071114103805.GA16652@infradead.org>
	<18234.53558.883970.87414@cargo.ozlabs.ibm.com>
	<20071114110009.GA17833@infradead.org>
	<20071114.031216.11725447.davem@davemloft.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:

> This is my impression too, all of the things being done with
> a slew of system calls would be better served by real special
> files and appropriate fops.

Special files and fops really only work well if you can coerce the
interface into one where data flows predominantly one way.  I don't
think they work so well for something that is more like an RPC across
the user/kernel barrier.  For that a system call is better.

For instance, if you have something that kind-of looks like

	read_pmds(int n, int *pmd_numbers, u64 *pmd_values);

where the caller supplies an array of PMD numbers and the function
returns their values (and you want that reading to be done atomically
in some sense), how would you do that using special files and fops?

>  Whether the thing is some kind
> of misc device or procfs is less important than simply getting
> away from these system calls.

Why?  What's inherently offensive about system calls?

Paul.
