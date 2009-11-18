Return-Path: <linux-kernel-owner+w=401wt.eu-S932150AbZKRSHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbZKRSHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758030AbZKRSHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:07:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56254 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997AbZKRSHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:07:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] BKL: Remove BKL from default_llseek()
Date: Wed, 18 Nov 2009 19:06:59 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>,
       linux-fsdevel@vger.kernel.org,
       "Linux-Kernel Mailinglist" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       =?iso-8859-1?q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
References: <1258560457-15129-1-git-send-email-jblunck@suse.de> <200911181833.37531.arnd@arndb.de> <20091118180044.3d5981bf@lxorguk.ukuu.org.uk>
In-Reply-To: <20091118180044.3d5981bf@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181906.59367.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ahD9PckgapOjLzTBEl1DZsnTU+LF+KeO8efh
 AKKQZ111sxaWnPpgJaZJizG3OCKI+ptnNhnltG7nd4dFRV/tGq
 ru7VP/yvngoKaXcDh4L9w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 November 2009, Alan Cox wrote:
> > There are drivers touching f_pos in ioctl() methods, which is vaguely
> > reasonable. There are also driver touching it in their read()/write()
> > methods, which has no effect whatsoever.
> 
> osst is the obvious offender. The ioctl ones like mtdchar seem to be
> broken but they have their own locking (or lack thereof) in there own
> lseek so its an internal proble,.
> 

The other ones I found before giving up are drivers/s390/char/tape_char.c
and drivers/sbus/char/flash.c.

	Arnd <><
