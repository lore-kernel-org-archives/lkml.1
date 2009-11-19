Return-Path: <linux-kernel-owner+w=401wt.eu-S1757676AbZKSCkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676AbZKSCkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 21:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757586AbZKSCkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 21:40:13 -0500
Received: from mail2.shareable.org ([80.68.89.115]:49508 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757298AbZKSCkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 21:40:12 -0500
Date: Thu, 19 Nov 2009 02:40:08 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oliver Neukum <oliver@neukum.org>, Jan Blunck <jblunck@suse.de>,
       linux-fsdevel@vger.kernel.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Hellwig <hch@infradead.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] BKL: Remove BKL from default_llseek()
Message-ID: <20091119024008.GB15128@shareable.org>
References: <1258560457-15129-1-git-send-email-jblunck@suse.de> <20091118171524.4d2f8cec@lxorguk.ukuu.org.uk> <20091118172730.GD28723@shareable.org> <200911181835.55007.oliver@neukum.org> <20091118175003.GF28723@shareable.org> <20091118181606.1c8caab1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118181606.1c8caab1@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> O> But nowadays, even that doesn't happen.  sys_read() and sys_write()
> > make a copy of f_pos using file_pos_read(), so drivers cannot see the
> > value change during the call - except for their own change.
> > 
> > I find myself wondering why the VFS isn't responsible for the position
> > update instead of the driver...  Would it be a valid cleanup to move
> > it from the driver to VFS?
> 
> And how would you adjust it. Not all devices have a bytes read == offset
> relationship. The VFS doesn't know enough.

That was implicit in my question: Are there any seekable devices where
bytes read != offset delta, and if yes, is that correct behaviour, a
bug, or a silly interface that should go away?

-- Jamie

