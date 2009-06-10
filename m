Return-Path: <linux-kernel-owner+w=401wt.eu-S1760109AbZFJKBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbZFJKBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 06:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZFJKBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 06:01:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54149 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbZFJKBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 06:01:11 -0400
Subject: Re: [PATCH 10/24] GFS2: Don't warn when delete inode fails on ro
 filesystem
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <20090610094942.GB25527@infradead.org>
References: <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-7-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-8-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-9-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-10-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-11-git-send-email-swhiteho@redhat.com>
	 <20090610094942.GB25527@infradead.org>
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Wed, 10 Jun 2009 11:03:17 +0100
Message-Id: <1244628197.3355.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-06-10 at 05:49 -0400, Christoph Hellwig wrote:
> On Wed, Jun 10, 2009 at 09:30:51AM +0100, Steven Whitehouse wrote:
> > If the filesystem is read-only, then we expect that delete inode
> > will fail, so there is no need to warn about it.
> 
> Umm, ->delete_inode should never be called on a read-only filesystem
> by the VFS.
> 

On a single node, thats true. With multiple nodes, some mounted ro and
some mounted rw, sometimes the ro node gets the baton passed to it, if
it happens to have a process holding open an inode thats been unlinked
on the rw node. In that case it has to ignore it and one of the rw nodes
will deal with the deallocation later,

Steve.


