Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbZERFna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbZERFna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 01:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZERFnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 01:43:20 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:38778 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752433AbZERFnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 01:43:19 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200905180532.n4I5Wxa1031243@turbo.physics.adelaide.edu.au>
Subject: Re: 2.9.29.2: ide-tape: panic when probing device at boot
To: petkovbb@gmail.com
Date: Mon, 18 May 2009 15:02:59 +0930 (CST)
Cc: bzolnier@gmail.com (Bartlomiej Zolnierkiewicz),
       jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       tj@kernel.org (Tejun Heo)
In-Reply-To: <20090509161801.GB5749@liondog.tnic> from "Borislav Petkov" at May 09, 2009 06:18:01 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, May 09, 2009 at 05:57:49PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > 
> > [ cc:ing linux-ide and knowledgeable people ]
> > 
> > Borislav/Tejun:
> > Is the 2.6.29 problem the same thing that was fixed recently?
> 
> I'll let Tejun answer that one since I don't get an oops. However, now
> that I have an ide-tape hardware here, I do get something DMA-related
> failing during boot ...
> :
> and more specifically the bad DMA info in identify block thing above. I
> haven't looked into it yet but its next on my TODO.

Cool.

> > Should I just push commit 1e75540ec5202cae63cd238c86bd880e3d496546
> > ("ide-tape: remove back-to-back REQUEST_SENSE detection") to Linus
> > or there is more needed to bring ide-tape to the world of living?
>
> The oops will probably fixed the above commit.  I don't have much idea
> about the DMA problem on 2.6.24 tho.  But even with the above commit
> fixed, I doubt it would work.  The buffer allocation code is broken
> and reliably triggered OOM on my test machine.  While trying to locate
> the bug, I realized the complex code didn't do much good to begin with
> and just stripped it down, so I didn't actually tracked down the
> actual bug && the patch to simplify buffer management is way too large
> for 2.6.29, so unless someone is willing to hunt down the bug just for
> 2.6.29, we're kind of stuck.  :-(

So I take it that 2.6.30 (or one of the RCs) is worth trying (at least in so
far as preventing the oops on boot)?

> ... and I'm afraid we'll have to do some serious bugfixing since this
> driver is behaving really funny :). Stay tuned, I'm on it.

Ok, I'll keep an eye out for updates.  Presumedly we're talking 2.6.31 or
.32 here.

Regards
  jonathan
