Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbZEDBBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbZEDBBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 21:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbZEDBBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 21:01:24 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:48601 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbZEDBBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 21:01:23 -0400
MIME-Version: 1.0
In-Reply-To: <f73f7ab80905031748v2be95af8vcd07c6a77dc348f@mail.gmail.com>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-2-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com>
	 <f73f7ab80905021651y54db1e69y87f0487bc06f0522@mail.gmail.com>
	 <20090503062720.GA31340@racke>
	 <f73f7ab80905030706i4afd0902ub42d42d60f01e6a2@mail.gmail.com>
	 <20090503224809.GB6243@racke>
	 <f73f7ab80905031748v2be95af8vcd07c6a77dc348f@mail.gmail.com>
Date: Sun, 3 May 2009 21:01:21 -0400
Message-ID: <f73f7ab80905031801n1e5ed6b6h84772baabda5f71e@mail.gmail.com>
Subject: Re: [PATCH 02/16] DRBD: lru_cache
From: Kyle Moffett <kyle@moffetthome.net>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Bart Van Assche <bart.vanassche@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 3, 2009 at 8:48 PM, Kyle Moffett <kyle@moffetthome.net> wrote:
> There are a couple trivial tunables you can apply to the model I
> provided to dramatically change the effect of memory pressure on the
> LRU:
>
> [...]
>

Ooh, I forgot to mention another biggie:  There's a way to allocate a
reserve pool of memory (I don't remember the exact API, sorry), which
can be attached to a specific kmem_cache to be used by processes
attempting writeout.  This would allow you to allocate more in-use
elements to make forward progress, even if all of your existing
elements are already in-use.

Cheers,
Kyle Moffett
