Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbZFOJ5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbZFOJ5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbZFOJ5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:57:38 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44626 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZFOJ5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:57:38 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nick Piggin <npiggin@suse.de>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
In-Reply-To: <1245059476.12400.7.camel@pasglop>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
	 <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com>
	 <20090615094148.GC1314@wotan.suse.de>  <1245059476.12400.7.camel@pasglop>
Date: Mon, 15 Jun 2009 12:57:39 +0300
Message-Id: <1245059859.23207.16.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 19:51 +1000, Benjamin Herrenschmidt wrote:
> I think the boot order is too likely to change to make it a sane thing
> to have all call sites "know" at what point they are in the boot
> process. In your example, what does GFP_BOOT would mean ? Before
> scheduler is initialized ? before interrupts are on ?

Btw, I think this is a pretty important point. Linus suggested trying to
make slab initialization even earlier than what we now have. If we do
require GFP_BOOT annotations, then we'd need to sprinkle those all over
the place when we do that.

So from code shuffling point of view, it's better to support GFP_KERNEL
(almost) everywhere rather than require special annotations.

			Pekka

