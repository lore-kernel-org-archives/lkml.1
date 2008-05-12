Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbYELDoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbYELDoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 23:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYELDns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 23:43:48 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58397 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbYELDnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 23:43:47 -0400
Date: Mon, 12 May 2008 09:13:41 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: David Newall <davidn@davidnewall.com>
Cc: Ulrich Drepper <drepper@redhat.com>, bsn.0007@gmail.com,
       libc-alpha@sourceware.org, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Christoph Hellwig <hch@lst.de>, Mingming Cao <cmm@us.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 1/2] Union Mount: glibc readdir support
Message-ID: <20080512034341.GA10541@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20080429133201.GA9938@localhost.localdomain> <20080429133346.GB9938@localhost.localdomain> <48195E69.3030701@redhat.com> <20080506042117.GA29298@in.ibm.com> <482058C4.8010104@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482058C4.8010104@davidnewall.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 10:40:28PM +0930, David Newall wrote:
> Bharata B Rao wrote:
> > Is dis-allowing NFS-exporting of unions an option ?
> 
> Is it that simple?  What about a union further in an NFS export?  What
> about union-mounting after the tree has been NFS-exported?

Ok I am realizing that it is not simple. I am actually reading up NFS
code to understand how it supports crossing of mountpoints. I see that
one can mount a filesystem within a NFS export and NFS server would be
able to cross over to that filesystem and provide those contents to the
client. Acutally Union Mount maintains union stack very similar to the
mount stack, but here we walk the union stack down. So I am checking if
something similar to mountpoint crossing would be able to solve the
problem of fetching all the contents of the NFS-exported union.

Answering my question to Erez that I raised in another thread, I see
that Unionfs doesn't set the export_operations in it's superblock and
hence I believe unions created by Unionfs aren't NFS-exportable as of
know. Erez, correct me if I got it wrong.

Regards,
Bharata.
