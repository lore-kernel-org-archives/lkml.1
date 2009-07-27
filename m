Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbZG0VCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbZG0VCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbZG0VCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:02:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35761 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753796AbZG0VCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:02:49 -0400
Date: Mon, 27 Jul 2009 22:02:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, axboe@kernel.dk, hch@infradead.org,
       akpm@linux-foundation.org, Paul.Clements@steeleye.com, tytso@mit.edu,
       Tejun Heo <tj@kernel.org>, miklos <miklos@szeredi.hu>
Subject: Re: [PATCH] Allow userspace block device implementation
Message-ID: <20090727220218.65a2adb2@lxorguk.ukuu.org.uk>
In-Reply-To: <4A6E0431.30000@redhat.com>
References: <4A6D79F6.3050509@redhat.com>
	<1248699365.6987.1628.camel@twins>
	<20090727142536.465799aa@lxorguk.ukuu.org.uk>
	<4A6E0431.30000@redhat.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you swap over NBD?  Assuming one had pinned the userspace program
> and it pre-allocated all memory so no pagein / alloc was required, would
> it be deadlock proof?  I believe there are structure allocations
> required for the socket implementation that go beyond the basic BIO
> allocations, therefore making it impossible.  In /theory/, one should be
> able to swap over this device.  In practice, it's probably a really bad
> idea.

In practice since you mmap an object for write and the only free pages
left may be mmap write dirty pages to go to a file system it ought to be
possible.
