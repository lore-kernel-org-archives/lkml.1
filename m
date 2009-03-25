Return-Path: <linux-kernel-owner+w=401wt.eu-S1760060AbZCYLnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060AbZCYLnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758823AbZCYLmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:42:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42683 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911AbZCYLmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:42:50 -0400
Date: Wed, 25 Mar 2009 12:42:48 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Manuel Lauss <mano@roarinelk.homelinux.net>, linux-kernel@vger.kernel.org
Subject: Re: MMC layer regression with single-block controllers
Message-ID: <20090325114248.GN27476@kernel.dk>
References: <20090323092802.GA30122@roarinelk.homelinux.net> <20090324210138.71029c2c@mjolnir.ossman.eu> <20090325104837.GA18389@roarinelk.homelinux.net> <20090325110401.GM27476@kernel.dk> <20090325123613.06404b17@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325123613.06404b17@mjolnir.ossman.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25 2009, Pierre Ossman wrote:
> On Wed, 25 Mar 2009 12:04:01 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > 
> > Well, as the warning tells you, it's not supported. But that doesn't
> > mean you can't do single sector transfers and complete the IO when you
> > have done all of them.
> > 
> 
> That's an annoying limitation and sort of defeats the purpose of
> specifying a maximum sector count. Why can't it go below 8?

Because it would add all sorts of complexity for handling 4kb block size
file systems on top of the block device. The bio_add_page() api depends
on being able to add a single page at least, it has to or you would need
to push that complexity to the callers.

So it's annoying, but you have to do the incremental completions
yourself for the (obscure) device that doesn't do more than 512b
transfers. It's really not that difficult, and it would be simpler than
supporting partial completions generically in the block layer.

Saying that it defeats the purpose of the setting is missing the bigger
picture - basically all other devices, that have sane limits (like 128k,
or whatnot).

-- 
Jens Axboe

