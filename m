Return-Path: <linux-kernel-owner+w=401wt.eu-S1751398AbXBMSDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbXBMSDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbXBMSDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:03:14 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46433 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbXBMSDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:03:14 -0500
Date: Tue, 13 Feb 2007 09:58:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <hansendc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 12/22] elevate write count files are open()ed
Message-Id: <20070213095817.d2a8a380.akpm@linux-foundation.org>
In-Reply-To: <1171385896.6202.20.camel@localhost.localdomain>
References: <20070209225329.27619A62@localhost.localdomain>
	<20070209225337.C8EC7257@localhost.localdomain>
	<20070212211148.c9069c97.akpm@linux-foundation.org>
	<1171385896.6202.20.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 13 Feb 2007 08:58:16 -0800 Dave Hansen <hansendc@us.ibm.com> wrote:
> > yipes.  A new mount-wide spin_lock/unlock for each for-writing open() and close().
> > Can we have a microbenchmark on this please?
> 
> Yeah, I'll schedule some dbench time on a NUMA machine.

dbench doesn't do open() a lot.  To assess the worst-case we'd need one
process per cpu camping in an open/close loop.
