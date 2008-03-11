Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbYCKIKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbYCKIKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 04:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYCKIJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 04:09:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbYCKIJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 04:09:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: bharata@linux.vnet.ibm.com
X-Fcc: ~/Mail/linus
Cc: libc-alpha@sourceware.org, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Christoph Hellwig <hch@lst.de>, Ulrich Drepper <drepper@redhat.com>,
       Mingming Cao <cmm@us.ibm.com>, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [RFC] Union mount readdir support in glibc
In-Reply-To: Bharata B Rao's message of  Tuesday, 11 March 2008 11:25:27 +0530 <20080311055527.GA7256@in.ibm.com>
References: <20080311055527.GA7256@in.ibm.com>
X-Zippy-Says: How many retired bricklayers from FLORIDA are out purchasing PENCIL
    SHARPENERS right NOW??
Message-Id: <20080311080929.B076D26F991@magilla.localdomain>
Date: Tue, 11 Mar 2008 01:09:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems very unlikely you'd come up with a version of this plan that we'd
find acceptable in glibc.  readdir does buffering, sometimes entry format
conversion, and it can skip dummy entries.  That's it.  It's not going to
become a big hairy thing with all kinds of new state.  Sorry.

This really is the kernel filesystem's problem.  It just doesn't make sense
to expect userland to implement half of your directory semantics for you.
What are you going to do when you want to export a union directory to NFS?
readdir is a filesystem operation.  You're implementing a filesystem.

Exposing DT_WHT entries may be useful as a user feature.  (BSD had unions
with whiteouts years ago, and their ls et al have options to let you see
and operate on whiteouts explicitly so users can make sense of strange
situations with unions.)  But even for that, we'd have to consider the
compatibility issues.


Thanks,
Roland
