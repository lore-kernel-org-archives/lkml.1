Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbZAFXJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbZAFXJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZAFXJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:09:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751643AbZAFXJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:09:31 -0500
Date: Tue, 6 Jan 2009 15:08:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Dmitri Monakhov <dmonakhov@openvz.org>
Subject: Re: 2.6.29 -mm merge plans
Message-Id: <20090106150855.5f362a2d.akpm@linux-foundation.org>
In-Reply-To: <20090106225744.GA10553@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<20090106225744.GA10553@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc added)

On Tue, 6 Jan 2009 17:57:44 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Jan 05, 2009 at 12:43:00AM -0800, Andrew Morton wrote:
> > fs-truncate-blocks-outside-i_size-after-o_direct-write-error.patch
> > fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
> 
> Btw, this code is still not quite right.  We really need to call
> ->setattr instead of vmtruncate here.  Complex filesystem need
> transaction to properly free blocks, and those transactions are in
> ->setattr not inside vmtruncate where ->truncate doesn't even have
> a chance to get the handle to the transaction passed.
> 
> As these patches don't make it worse this is not a NACK, but more of
> a heads up.

Sure.  Maybe add a FIXME comment for now?
