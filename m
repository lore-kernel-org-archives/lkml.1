Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbZDGHyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbZDGHyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbZDGHyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:54:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35038 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbZDGHyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:54:12 -0400
Date: Tue, 7 Apr 2009 09:56:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       David Rientjes <rientjes@google.com>, Chris Worley <worleys@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Off topic: Numactl "distance" wrong
Message-ID: <20090407075621.GK17934@one.firstfloor.org>
References: <86802c440904031448yc6d499ckd9cb969ce136f477@mail.gmail.com> <87r609jtc2.fsf@basil.nowhere.org> <20090407111539.F0F5.A69D9226@jp.fujitsu.com> <49DAF003.1070605@inria.fr> <20090407070530.GJ17934@one.firstfloor.org> <49DB0388.1040408@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DB0388.1040408@inria.fr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 09:40:56AM +0200, Brice Goglin wrote:
> Andi Kleen wrote:
> >> Well, some user-space application may use these distances
> >> to improve their binding.
> >>     
> >
> > I'm not aware of any that does.
> 
> We have some people here that would like to use it ideally. But they
> know numa distances is almost never available, so they don't really look
> at using them...

>From my experience and from talking at people they tend to have enough
trouble getting the basic NUMA tunings done, without caring about
such (arcane) details.

> 
> > If it's true then the correct place would be to fix the BIOS.
> >   
> 
> Come on, you know it's not going to happen for 99.9% on the existing
> opteron boxes. We have many hardware quirks in the kernel, I don't see
> why this numa distance problem would not deserve its own work around.

The systems where it makes a large difference typically have them anyways.

Anyways if you really want you can ask Len for a way to override SLIT
tables at boot time (similar to the mechanism for MADTs), but I suspect
he wouldn't be particularly enthuiastic. Also it's a little more tricky
than for normal MADTs because SLIT parsing happens very early.

> By the way, anybody looked at this on Nehalem boxes ?

Current Nehalem boxes are all fully connected, so 10/20 
(or sometimes scaled to trigger the zone fallback workaround) is the
correct answer and you don't get any benefits from magic in this area.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
