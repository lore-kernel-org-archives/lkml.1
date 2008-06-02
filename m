Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbYFBF4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbYFBF4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 01:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYFBFzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 01:55:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33463 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbYFBFzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 01:55:50 -0400
Date: Mon, 2 Jun 2008 01:55:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, agruen@suse.de, jjohansen@suse.de
Subject: Re: [patch 3/8] Make d_path() consistent across mount operations
Message-ID: <20080602055548.GA4296@infradead.org>
References: <20080529113245.450308367@szeredi.hu> <20080529113310.608958055@szeredi.hu> <20080531082210.GD24135@infradead.org> <E1K2uK3-0001cR-A4@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K2uK3-0001cR-A4@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 10:38:35PM +0200, Miklos Szeredi wrote:
> > > The path that __d_path() computes can become slightly inconsistent when it
> > > races with mount operations: it grabs the vfsmount_lock when traversing mount
> > > points but immediately drops it again, only to re-grab it when it reaches the
> > > next mount point.  The result is that the filename computed is not always
> > > consisent, and the file may never have had that name. (This is unlikely, but
> > > still possible.)
> > > 
> > > Fix this by grabbing the vfsmount_lock for the whole duration of
> > > __d_path().
> > 
> > Looks good, and lock holding times shouldn't be a problem either.
> 
> Thanks for the review of this batch.
> 
> Can you please in the future either explicitly ACK or NACK?  Because I
> really wouldn't want any more of this "Looks good, but bla bla bla"
> and then NACKing the patch when I send it off to Andrew.

ACK for patches 1-3.

