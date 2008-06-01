Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbYFAUiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbYFAUiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 16:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYFAUio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 16:38:44 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37609 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbYFAUin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 16:38:43 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, agruen@suse.de,
       jjohansen@suse.de
In-reply-to: <20080531082210.GD24135@infradead.org> (message from Christoph
	Hellwig on Sat, 31 May 2008 04:22:10 -0400)
Subject: Re: [patch 3/8] Make d_path() consistent across mount operations
References: <20080529113245.450308367@szeredi.hu> <20080529113310.608958055@szeredi.hu> <20080531082210.GD24135@infradead.org>
Message-Id: <E1K2uK3-0001cR-A4@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 01 Jun 2008 22:38:35 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The path that __d_path() computes can become slightly inconsistent when it
> > races with mount operations: it grabs the vfsmount_lock when traversing mount
> > points but immediately drops it again, only to re-grab it when it reaches the
> > next mount point.  The result is that the filename computed is not always
> > consisent, and the file may never have had that name. (This is unlikely, but
> > still possible.)
> > 
> > Fix this by grabbing the vfsmount_lock for the whole duration of
> > __d_path().
> 
> Looks good, and lock holding times shouldn't be a problem either.

Thanks for the review of this batch.

Can you please in the future either explicitly ACK or NACK?  Because I
really wouldn't want any more of this "Looks good, but bla bla bla"
and then NACKing the patch when I send it off to Andrew.

Miklos
