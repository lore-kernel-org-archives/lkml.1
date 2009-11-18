Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbZKRRfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbZKRRfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758021AbZKRRfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:35:52 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:54475 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989AbZKRRfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:35:51 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 1/2] BKL: Remove BKL from default_llseek()
Date: Wed, 18 Nov 2009 18:35:54 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jan Blunck <jblunck@suse.de>,
       linux-fsdevel@vger.kernel.org,
       "Linux-Kernel Mailinglist" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Hellwig <hch@infradead.org>,
       =?iso-8859-1?q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
References: <1258560457-15129-1-git-send-email-jblunck@suse.de> <20091118171524.4d2f8cec@lxorguk.ukuu.org.uk> <20091118172730.GD28723@shareable.org>
In-Reply-To: <20091118172730.GD28723@shareable.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181835.55007.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 18. November 2009 18:27:30 schrieb Jamie Lokier:
> > No. Your logic is flawed
> > 
> > The BKL is protected something here - it protects the change of offset
> > with respect to other BKL users within drivers. The question is what if
> > anything in any other driver code depends upon the BKL and uses it to
> > protect f_pos. Probably very little if anything but a grep for f_pos
> > through the drivers might not be a bad idea before assuming this. Very
> > few touch f_pos except in their own llseek method.
> 
> Of course, drivers shouldn't be using f_pos outside their llseek
> method, as they should all behave the same with pread/pwrite as with
> llseek+read/write.

Might not a driver update f_pos after read/write?

	Regards
		Oliver
