Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbZJFRpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbZJFRpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757729AbZJFRpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:45:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140AbZJFRpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:45:41 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: zach.brown@oracle.com
Cc: linux-aio <linux-aio@kvack.org>,
       Linux Kernel Mailing <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v4 0/3] aio: implement request batching [more performance numbers]
References: <x49zl8976g3.fsf@segfault.boston.devel.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 06 Oct 2009 13:45:03 -0400
In-Reply-To: <x49zl8976g3.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Fri, 02 Oct 2009 18:54:20 -0400")
Message-ID: <x49eipga02o.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a mail I got from Nathan Roberts.

Cheers,
Jeff

---

Similar test as before. I had to re-upload the files so comparing
against last time isn't really apples-apples.

Disk is a cciss logical drive consisting of 12 SATA drives in a RAID6
configuration with 128K stripes.

Test case 1 is to read 1 million random 40K files (no file is read
more than once), 16 4K iocbs at a time, 100 threads.

Test case 2 is the same except 100,000 128K files are read.

Unit of measure is "files read per second".


40K
-------------------------------------------------
Kernel                              NOOP
------                              ----
2.6.30.5                            682
2.6.30.5 (w/o drop_caches)          718
2.6.30.5+patch_v4                   900
2.6.30.5+patch_v4 (w/o drop caches) 965


128K
-------------------------------------------------
Kernel                              NOOP
------                              ----
2.6.30.5                            242
2.6.30.5 (w/o drop_caches)          350
2.6.30.5+patch_v4                   292
2.6.30.5+patch_v4 (w/o drop caches) 420


Hope it helps.
Nathan

