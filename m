Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbXDIWry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbXDIWry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 18:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbXDIWry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 18:47:54 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:60916 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbXDIWrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 18:47:53 -0400
Date: Mon, 9 Apr 2007 18:47:41 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL -mm] Unionfs branch management code
Message-ID: <20070409224741.GA9389@filer.fsl.cs.sunysb.edu>
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu> <20070409104948.2bc99202.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409104948.2bc99202.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 10:49:48AM -0700, Andrew Morton wrote:
> On Mon,  9 Apr 2007 10:53:51 -0400 "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu> wrote:
> 
> > The following patches introduce new branch-management code into Unionfs as
> > well as fix a number of stability issues and resource leaks.

First, a quick note...Unionfs used to have branch management code, but the
code was so crufty that we decided to spare the eyes (and brains) of kernel
developers at large by ripping it out. This series of patches just
reintroduces the functionality in a sane way. With that said...

> I have a mental note that unionfs is in the "stuck" state, due to general
> agreement that we should implement this functionality at the VFS level, one
> reason for which is unionfs's upper-vs-lower coherency problems.

Right. The upper-vs-lower coherency problem is indeed a problem, but it is
not a _Unionfs_ problem, but rather a _stackable filesystems_ problem
(eCrypfs suffers from the same issue people are just less likely to trip
over it as no one in their right mind modifies encrypted data by hand). If
we hope to have Linux do stacking (which, I think makes sense), we need to
make few changes to the kernel to allow stackable filesystems to work
better, and safer. We're working on an OLS paper which discusses some of
these ideas (some of which we got at LSF back in February) - for example, do
we want to have strong or weak cache coherency? (When the lower pages
change, do we want to have the VM enforce coherency, or can we use more of
an NFS-like coherency model - checking {a,c,m}time.)

Josef "Jeff" Sipek.

-- 
Intellectuals solve problems; geniuses prevent them
		- Albert Einstein
