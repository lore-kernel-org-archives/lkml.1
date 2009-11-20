Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbZKTRNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbZKTRNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbZKTRNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:13:18 -0500
Received: from mail2.shareable.org ([80.68.89.115]:33875 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbZKTRNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:13:17 -0500
Date: Fri, 20 Nov 2009 17:13:17 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Willem Riede <osst@riede.org>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>
Subject: Re: [PATCH 03/15] osst: Update ppos instead of using file->f_pos
Message-ID: <20091120171317.GH20634@shareable.org>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de> <1258735245-25826-4-git-send-email-jblunck@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258735245-25826-4-git-send-email-jblunck@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Blunck wrote:
> osst_read()/osst_write() modify file->f_pos directly instead of the ppos
> given to them. The VFS later updates the file->f_pos and overwrites it
> with the value of ppos.

I notice st.c doesn't use or update file->f_pos (or *ppos), so
userspace probably won't be caring about f_pos from osst.c (they're
both SCSI tape drivers).  And osst.c doesn't use the value, it just
increases it with each transfer.  It doesn't even reset the value to
zero when rewinding the tape, so it's not that meaningful.

So how about just removing those modifications to file->f_pos from osst.c?

-- Jamie
