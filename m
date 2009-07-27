Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbZG0UXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbZG0UXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbZG0UXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:23:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55056 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbZG0UXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:23:05 -0400
Subject: Re: [PATCH] Allow userspace block device implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, axboe@kernel.dk, hch@infradead.org,
       akpm@linux-foundation.org, Paul.Clements@steeleye.com, tytso@mit.edu,
       Tejun Heo <tj@kernel.org>, miklos <miklos@szeredi.hu>
In-Reply-To: <4A6E0431.30000@redhat.com>
References: <4A6D79F6.3050509@redhat.com>	<1248699365.6987.1628.camel@twins>
	 <20090727142536.465799aa@lxorguk.ukuu.org.uk>  <4A6E0431.30000@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Jul 2009 22:24:44 +0200
Message-Id: <1248726284.6987.2068.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 09:46 -1000, Zachary Amsden wrote:
> Can you swap over NBD?  Assuming one had pinned the userspace program
> and it pre-allocated all memory so no pagein / alloc was required, would
> it be deadlock proof?  I believe there are structure allocations
> required for the socket implementation that go beyond the basic BIO
> allocations, therefore making it impossible.  In /theory/, one should be
> able to swap over this device.  In practice, it's probably a really bad
> idea.

I've got patches to make swap over network work, with those swap over
NBD works until you loose connection. NBDs great weakness (aside from
funny code) is that it does the connection management in userspace,
which makes recovering from connection loss when swapping over it
utterly impossible.
