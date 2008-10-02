Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYJBNNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYJBNNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 09:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYJBNM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 09:12:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:52067 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbYJBNM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:12:56 -0400
Date: Thu, 2 Oct 2008 06:12:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002061236.3c71c877@infradead.org>
In-Reply-To: <20081001235501.2b7f50fe.akpm@linux-foundation.org>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
	<20081002062736.GR19428@kernel.dk>
	<20081001235501.2b7f50fe.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 23:55:01 -0700
> 
> I've forgotten where that code is now, but I don't think it was ever
> revisited.  It should be.
> 
> So.  Where are these atime updaters getting blocked?

my reproducer is sadly very simple (claws-mail is my mail client that uses maildir)

Process claws-mail (4896)                  Total: 2829.7 msec 
EXT3: Waiting for journal access                  2491.0 msec         88.4 % 
Writing back inodes				   160.9 msec          5.7 % 
synchronous write                                   78.8 msec          3.0 %

is an example of such a trace (this is with patch, without patch the numbers are about 3x bigger)

Waiting for journal access is "journal_get_write_access"
Writing back inodes is "writeback_inodes"
synchronous write is "do_sync_write"


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
