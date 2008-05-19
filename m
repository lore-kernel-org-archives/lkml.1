Return-Path: <linux-kernel-owner+w=401wt.eu-S1761013AbYESODK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761013AbYESODK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 10:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbYESOC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 10:02:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46186 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693AbYESOCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 10:02:55 -0400
Date: Mon, 19 May 2008 10:02:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Trond.Myklebust@netapp.com, swhiteho@redhat.com, sfrench@samba.org,
       vandrove@vc.cvut.cz, corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/11] Remove BKL from remote_llseek
Message-ID: <20080519140235.GA24267@infradead.org>
References: <20080519231.561421028@firstfloor.org> <20080519123110.930491B41FF@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519123110.930491B41FF@basil.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 02:31:10PM +0200, Andi Kleen wrote:
> 
> - Replace remote_llseek with remote_llseek_unlocked (to force compilation 
> failures in all users)
> - Change all users to either use remote_llseek directly or take the
> BKL around. I changed the file systems who don't use the BKL
> for anything (CIFS, GFS) to call it directly. NCPFS and SMBFS and NFS
> take the BKL, but explicitely in their own source now.
> 
> I moved them all over in a single patch to avoid unbisectable sections.

Good idea, but it could be done a little bit nicer still.

Your new remote_llseek_unlocked is the same as generic_file_llseek
except for the fact that it doesn't take i_mutex.  So I'd rather
call it generic_file_llseek_nolock and make generic_file_llseek call
it.  While you're at it you could also add some kerneldoc documents
describing them.

