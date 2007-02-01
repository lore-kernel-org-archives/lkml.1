Return-Path: <linux-kernel-owner+w=401wt.eu-S1161120AbXBAAaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161120AbXBAAaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161116AbXBAAaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:30:17 -0500
Received: from smtp.osdl.org ([65.172.181.24]:32847 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161121AbXBAAaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:30:15 -0500
Date: Wed, 31 Jan 2007 16:26:31 -0800
From: Andrew Morton <akpm@osdl.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?ISO-8859-1?Q?Pawe=C5?= Sikora <pluto@agmk.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Martin Peschke <mp3@de.ibm.com>, Adrian Bunk <bunk@stusta.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Linux 2.6.20-rc7
Message-Id: <20070131162631.4ae5800d.akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0701311609210.3632@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
	<45C05150.6000802@agmk.net>
	<Pine.LNX.4.64.0701310748450.3632@woody.linux-foundation.org>
	<200702010037.48472.pluto@agmk.net>
	<Pine.LNX.4.64.0701311609210.3632@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007 16:19:06 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I should either revert that commit or just check for "free_pages" being 
> negative. The latter, in many ways, is probably better, because generally 
> we simply should never work with negative numbers in the kernel, so when 
> something potentially goes negative, we're probably just better off always 
> testing it explicitly anyway.
> 
> Nick, Andrew, any preferences? 

It would be cleaner to check for negativity, but note that we keep
subtracting stuff from free_pages in the later loop, so we'd need to check
there as well.

