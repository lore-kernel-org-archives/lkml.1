Return-Path: <linux-kernel-owner+w=401wt.eu-S1751568AbZHZQIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbZHZQIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZHZQIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:08:13 -0400
Received: from smtp4.ultrahosting.com ([74.213.175.253]:38856 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751140AbZHZQIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:08:13 -0400
Date: Wed, 26 Aug 2009 12:07:47 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Nitin Gupta <ngupta@vflare.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-mm-cc@laptop.org
Subject: Re: [PATCH 1/4] compcache: xvmalloc memory allocator
In-Reply-To: <4A92EBB4.1070101@vflare.org>
Message-ID: <alpine.DEB.1.10.0908261204400.9933@gentwo.org>
References: <200908241007.47910.ngupta@vflare.org> <84144f020908241033l4af09e7h9caac47d8d9b7841@mail.gmail.com> <4A92EBB4.1070101@vflare.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009, Nitin Gupta wrote:

> PFNs are 32-bit on all archs while for 'struct page *', we require 32-bit or
> 64-bit depending on arch. ramzswap allocates a table entry <pagenum, offset>
> corresponding to every swap slot. So, the size of table will unnecessarily
> increase on 64-bit archs. Same is the argument for xvmalloc free list sizes.

Wrong. PFNs must be longer than 32 bit otherwise a system cannot
address more than 2^12 + 2^32 = 2^44 =>  16TB.

The type used for PFNs is unsigned long which are 64 bit on 64 bit platforms.

