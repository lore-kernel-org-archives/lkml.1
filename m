Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbZJVCwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbZJVCwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 22:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbZJVCwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 22:52:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44489 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbZJVCwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 22:52:23 -0400
Date: Wed, 21 Oct 2009 22:52:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arndbergmann@googlemail.com>
Cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mattia Dongili <malattia@linux.it>
Subject: Re: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
Message-ID: <20091022025224.GA17438@infradead.org>
References: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain> <200910200008.57468.arnd@arndb.de> <alpine.LFD.2.00.0910210157170.8674@localhost.localdomain> <200910211029.21702.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910211029.21702.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 10:29:21AM +0200, Arnd Bergmann wrote:
> Well, for this specific case, the driver does not actually need to seek,
> because the read function never looks at the position and there is no
> write function. For annotation purposes, IMHO we should have a simple
> '.llseek = no_llseek' in there.

Which is normal for character drivers.  Even better you should use
nonseekable_open to also prevent pread/pwrite.

