Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbZKRSOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbZKRSOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758047AbZKRSOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:14:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43559 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758030AbZKRSOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:14:47 -0500
Date: Wed, 18 Nov 2009 18:16:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jamie Lokier <jamie@shareable.org>
Cc: Oliver Neukum <oliver@neukum.org>, Jan Blunck <jblunck@suse.de>,
       linux-fsdevel@vger.kernel.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Hellwig <hch@infradead.org>,
       =?ISO-8859-14?B?RnLpZOlyaWM=?= Weisbecker <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] BKL: Remove BKL from default_llseek()
Message-ID: <20091118181606.1c8caab1@lxorguk.ukuu.org.uk>
In-Reply-To: <20091118175003.GF28723@shareable.org>
References: <1258560457-15129-1-git-send-email-jblunck@suse.de>
	<20091118171524.4d2f8cec@lxorguk.ukuu.org.uk>
	<20091118172730.GD28723@shareable.org>
	<200911181835.55007.oliver@neukum.org>
	<20091118175003.GF28723@shareable.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> But nowadays, even that doesn't happen.  sys_read() and sys_write()
> make a copy of f_pos using file_pos_read(), so drivers cannot see the
> value change during the call - except for their own change.
> 
> I find myself wondering why the VFS isn't responsible for the position
> update instead of the driver...  Would it be a valid cleanup to move
> it from the driver to VFS?

And how would you adjust it. Not all devices have a bytes read == offset
relationship. The VFS doesn't know enough.
