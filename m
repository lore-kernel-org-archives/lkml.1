Return-Path: <linux-kernel-owner+w=401wt.eu-S932629AbZKRTST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629AbZKRTST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 14:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932609AbZKRTSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 14:18:18 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62914 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611AbZKRTSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 14:18:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] BKL: Remove BKL from default_llseek()
Date: Wed, 18 Nov 2009 20:17:26 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>,
       linux-fsdevel@vger.kernel.org,
       "Linux-Kernel Mailinglist" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       =?iso-8859-1?q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
References: <1258560457-15129-1-git-send-email-jblunck@suse.de> <200911181833.37531.arnd@arndb.de> <20091118181433.50b1b707@lxorguk.ukuu.org.uk>
In-Reply-To: <20091118181433.50b1b707@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911182017.26266.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/2JI1xCnBuNvaTvrN+SfLo2n8gigIC1zbtfPl
 fS9hNskc0smJm0R45qxmxqVJpBtX9jjR1CGojGnGavBB06p8Dc
 W+qBfJBRVbnJgxImEq4KA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 November 2009, Alan Cox wrote:
> Stuff that looks trivial to salvage and works if you don't pread/write I
> imagine
> 
> drivers/sbus/char/flash.c

It also breaks if you do consecutive read() operations without an lseek
between them, because read() does not update *pos. It should work if you
read the whole thing with a single read() operation though, like
the other drivers you mentioned.

	Arnd <><
