Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbZGHT4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbZGHT4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 15:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbZGHT4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 15:56:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:45379 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbZGHT4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 15:56:38 -0400
Subject: Re: [PATCH 1/3] Increase lockdep limits: MAX_STACK_TRACE_ENTRIES
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <a5d9929e0907081248q51e1fcfekff4c1b814e512184@mail.gmail.com>
References: <a5d9929e0907070825j1dda6584t93196e2730dedc5c@mail.gmail.com>
	 <1246980836.9777.5.camel@twins>
	 <a5d9929e0907070838q7ed3306du3bb7880e47d7207b@mail.gmail.com>
	 <1246981444.9777.11.camel@twins>
	 <a5d9929e0907070850v72cd4da4y1cbbb10fddebd575@mail.gmail.com>
	 <1246982101.9777.15.camel@twins> <20090708172248.GB2521@redhat.com>
	 <1247078164.16156.18.camel@laptop>
	 <a5d9929e0907081248q51e1fcfekff4c1b814e512184@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 21:56:29 +0200
Message-Id: <1247082989.16156.19.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 20:48 +0100, Joao Correia wrote:
> 
> 
> Im in no way pretending to understand all the details on this system,
> but i do know there has been, as of late, an effort to make the init
> process do more things at once, ie, load more modules in parallel to
> speed up the process. Can't that be at least partially responsible for
> this? Even if its just making some other problem more obvious?

Nah, lockdep serializes all that under a single lock ;-)

module unloading in particular wastes resources from a lockdep pov, so
as long as that doesn't happen, we're good.

