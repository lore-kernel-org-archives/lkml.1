Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbZKSKMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbZKSKMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 05:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbZKSKMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 05:12:40 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41745 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755337AbZKSKMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 05:12:39 -0500
Date: Thu, 19 Nov 2009 10:13:30 +0000
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
Message-ID: <20091119101330.5a09d6b0@lxorguk.ukuu.org.uk>
In-Reply-To: <20091119024008.GB15128@shareable.org>
References: <1258560457-15129-1-git-send-email-jblunck@suse.de>
	<20091118171524.4d2f8cec@lxorguk.ukuu.org.uk>
	<20091118172730.GD28723@shareable.org>
	<200911181835.55007.oliver@neukum.org>
	<20091118175003.GF28723@shareable.org>
	<20091118181606.1c8caab1@lxorguk.ukuu.org.uk>
	<20091119024008.GB15128@shareable.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That was implicit in my question: Are there any seekable devices where
> bytes read != offset delta, and if yes, is that correct behaviour, a
> bug, or a silly interface that should go away?

It's neither a bug nor silly, although some of our users of it are a bit
strange.

Consider a block based device. It makes complete sense then that a short
read (eg user space passing a small buffer) causes the seek position to
move on one block. Ditto a block based system with EOF markers might do
that (eg some tape systems).

In the weirdness (but API) category we have things like the MSR driver
which returns an entire MSR for each byte offset.

Alan
