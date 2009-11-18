Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbZKRRzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbZKRRzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932136AbZKRRzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:55:36 -0500
Received: from cantor.suse.de ([195.135.220.2]:43551 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142AbZKRRzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:55:35 -0500
Date: Wed, 18 Nov 2009 18:55:40 +0100
From: Jan Blunck <jblunck@suse.de>
To: Oliver Neukum <oliver@neukum.org>
Cc: Jamie Lokier <jamie@shareable.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-fsdevel@vger.kernel.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Hellwig <hch@infradead.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] BKL: Remove BKL from default_llseek()
Message-ID: <20091118175540.GR21750@bolzano.suse.de>
References: <1258560457-15129-1-git-send-email-jblunck@suse.de> <20091118171524.4d2f8cec@lxorguk.ukuu.org.uk> <20091118172730.GD28723@shareable.org> <200911181835.55007.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911181835.55007.oliver@neukum.org>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, Oliver Neukum wrote:

> Am Mittwoch, 18. November 2009 18:27:30 schrieb Jamie Lokier:
> > > No. Your logic is flawed
> > > 
> > > The BKL is protected something here - it protects the change of offset
> > > with respect to other BKL users within drivers. The question is what if
> > > anything in any other driver code depends upon the BKL and uses it to
> > > protect f_pos. Probably very little if anything but a grep for f_pos
> > > through the drivers might not be a bad idea before assuming this. Very
> > > few touch f_pos except in their own llseek method.
> > 
> > Of course, drivers shouldn't be using f_pos outside their llseek
> > method, as they should all behave the same with pread/pwrite as with
> > llseek+read/write.
> 
> Might not a driver update f_pos after read/write?

Actually the VFS is doing that for you in read/write syscall. So anything you
change in your driver gets corrected (or overwritten anyway).

Regards,
	Jan

-- 
Jan Blunck <jblunck@suse.de>
