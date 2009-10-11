Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbZJKJFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbZJKJFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 05:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZJKJFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 05:05:21 -0400
Received: from tneu02.synserver.de ([217.119.58.222]:3456 "EHLO
	tneu02.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbZJKJFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 05:05:20 -0400
X-Greylist: delayed 645 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Oct 2009 05:05:20 EDT
From: Thomas Neumann <tneumann@users.sourceforge.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: deadlock with fallocate
Date: Sun, 11 Oct 2009 10:53:56 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.28-15-generic; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com,
       Christoph Hellwig <hch@lst.de>
References: <hah08m$p1a$1@ger.gmane.org> <20091011005746.56cd3cd4.akpm@linux-foundation.org>
In-Reply-To: <20091011005746.56cd3cd4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910111053.57159.tneumann@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Will legacy applications fail on newer kernels?  Or is it the case that
> only recently-written applications which utilise new kernel
> functionality will hit this bug?
In theory posix_fallocate has been around for a while and glibc will use 
kernel functionality if available, so applications might break. In practice it 
is perhaps not that common that applications use fallocate.

The problem is definitively fallocate related. When I replace possix_fallocate 
with the equivalent ftruncate64 call the problem goes away. (But then again 
the two calls are not really equivalent, and fallocate is the semantic that I 
need).
Furthermore the deadlocks seem to start occurring after writing more data than 
available main memory, but I did not investigate this thoroughly.

Thomas

