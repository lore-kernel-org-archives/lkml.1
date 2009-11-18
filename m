Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbZKRR1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbZKRR1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757974AbZKRR1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:27:31 -0500
Received: from mail2.shareable.org ([80.68.89.115]:35770 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879AbZKRR1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:27:30 -0500
Date: Wed, 18 Nov 2009 17:27:30 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jan Blunck <jblunck@suse.de>, linux-fsdevel@vger.kernel.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Hellwig <hch@infradead.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] BKL: Remove BKL from default_llseek()
Message-ID: <20091118172730.GD28723@shareable.org>
References: <1258560457-15129-1-git-send-email-jblunck@suse.de> <20091118171524.4d2f8cec@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118171524.4d2f8cec@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> > Using the BKL in llseek() does not protect the inode's i_size from
> > modification since the i_size is protected by a seqlock nowadays. Since
> > default_llseek() is already using the i_size_read() wrapper it is not the
> > BKL which is serializing the access here.
> > The access to file->f_pos is not protected by the BKL either since its
> > access in vfs_write()/vfs_read() is not protected by any lock. If the BKL
> > is not protecting anything here it can clearly get removed.
> 
> No. Your logic is flawed
> 
> The BKL is protected something here - it protects the change of offset
> with respect to other BKL users within drivers. The question is what if
> anything in any other driver code depends upon the BKL and uses it to
> protect f_pos. Probably very little if anything but a grep for f_pos
> through the drivers might not be a bad idea before assuming this. Very
> few touch f_pos except in their own llseek method.

Of course, drivers shouldn't be using f_pos outside their llseek
method, as they should all behave the same with pread/pwrite as with
llseek+read/write.

Is that mistaken?

-- Jamie
