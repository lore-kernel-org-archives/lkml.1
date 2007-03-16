Return-Path: <linux-kernel-owner+w=401wt.eu-S965384AbXCPOpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965384AbXCPOpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 10:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965378AbXCPOpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 10:45:45 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33553 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965356AbXCPOpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 10:45:43 -0400
Date: Fri, 16 Mar 2007 16:45:39 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/5] revoke: core code
In-Reply-To: <20070316042600.3e1bd424.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703161637001.26209@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703111330100.765@sbz-30.cs.Helsinki.FI>
 <20070315173438.efadd514.akpm@linux-foundation.org>
 <84144f020703152344u588da670ge14c1ec5797c2b86@mail.gmail.com>
 <20070316032624.c6db84fc.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703161331580.21300@sbz-30.cs.Helsinki.FI>
 <20070316042600.3e1bd424.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007, Andrew Morton wrote:
> What you're trying to do here is very similar to truncate(), and truncate()
> has had a lot of work put into it, and it does work.

Indeed. revoke() is the same as truncate() without, well, the truncation 
part.

On Fri, 16 Mar 2007, Andrew Morton wrote:
> However, modifying i_size like this might be a problem - the inode could be
> dirty and it'll get written to disk!  Perhaps we could change i_size_read()
> to cheat and to return zero if there's a revoke in progress.

Hmph, it's probably going to get too painful so I'll look at adding some 
hooks to do_generic_mapping_read()...

			Pekka
