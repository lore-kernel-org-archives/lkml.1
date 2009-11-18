Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbZKRR7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbZKRR7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbZKRR7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:59:23 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51652 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758141AbZKRR7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:59:22 -0500
Date: Wed, 18 Nov 2009 18:00:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>,
       linux-fsdevel@vger.kernel.org,
       "Linux-Kernel Mailinglist" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       =?ISO-8859-14?B?RnLpZOlyaWM=?= Weisbecker <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] BKL: Remove BKL from default_llseek()
Message-ID: <20091118180044.3d5981bf@lxorguk.ukuu.org.uk>
In-Reply-To: <200911181833.37531.arnd@arndb.de>
References: <1258560457-15129-1-git-send-email-jblunck@suse.de>
	<20091118171524.4d2f8cec@lxorguk.ukuu.org.uk>
	<20091118172730.GD28723@shareable.org>
	<200911181833.37531.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There are drivers touching f_pos in ioctl() methods, which is vaguely
> reasonable. There are also driver touching it in their read()/write()
> methods, which has no effect whatsoever.

osst is the obvious offender. The ioctl ones like mtdchar seem to be
broken but they have their own locking (or lack thereof) in there own
lseek so its an internal proble,.

> 
> I started grepping through the kernel trying to find any instances
> of the first case that uses the BKL, but I only found three instances
> of the second case and got heavily demotivated by that.

osst probably wants to get an && BROKEN
