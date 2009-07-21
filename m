Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbZGUVzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbZGUVzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbZGUVzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:55:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51722 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbZGUVzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:55:44 -0400
Date: Tue, 21 Jul 2009 17:55:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org,
       Hans-Joachim Picht <hans@linux.vnet.ibm.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arnd Schneider <arnd@de.ibm.com>, linux-fsdevel@vger.kernel.org
Subject: Re: PM/hibernate swapfile regression
Message-ID: <20090721215536.GA9502@infradead.org>
References: <20090714135453.GA26976@osiris.boeblingen.de.ibm.com> <200907141821.06101.rjw@sisk.pl> <4A6077DE.6060202@tuffmail.co.uk> <20090720132456.GA29023@osiris.boeblingen.de.ibm.com> <4A659D75.3050004@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A659D75.3050004@tuffmail.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 11:50:29AM +0100, Alan Jenkins wrote:
> +struct block_device *bdcopy(struct block_device *bdev)
> +{
> +	atomic_inc(&bdev->bd_inode->i_count);
> +	return bdev;
> +}
> +
> +EXPORT_SYMBOL(bdcopy);

The function name doesn't make any sense.  You don't copy anything
here, but you grab a reference to it.  A better name would be bdgrab,
mirroing the names of functions like igrab.  A kerneldoc comment
documenting it would also be very helpful.

Why do you export it?  The swapfile code is not actually modular.

