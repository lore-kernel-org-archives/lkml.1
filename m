Return-Path: <linux-kernel-owner+w=401wt.eu-S932769AbXAZKuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769AbXAZKuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 05:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932832AbXAZKuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 05:50:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55542 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932769AbXAZKuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 05:50:40 -0500
Date: Fri, 26 Jan 2007 02:27:15 -0800
From: Andrew Morton <akpm@osdl.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Aubrey Li <aubreylee@gmail.com>, Christoph Lameter <clameter@sgi.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, dgc@sgi.com
Subject: Re: [RFC] Limit the size of the pagecache
Message-Id: <20070126022715.afad8716.akpm@osdl.org>
In-Reply-To: <45B6DA8B.7060004@yahoo.com.au>
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
	<45B6CBD9.80600@yahoo.com.au>
	<Pine.LNX.4.64.0701231908420.6123@schroedinger.engr.sgi.com>
	<6d6a94c50701231951o66487813vcd078fc25e25ffa0@mail.gmail.com>
	<45B6DA8B.7060004@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jan 2007 15:03:23 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> 
> Yeah, it will be failing at order=4, because the allocator won't try
> very hard reclaim pagecache pages at that cutoff point. This needs to
> be fixed in the allocator.

A simple and perhaps sufficient fix for this nommu problem would be to replace
the magic "3" in __alloc_pages() with a tunable.
