Return-Path: <linux-kernel-owner+w=401wt.eu-S1762454AbZEGRv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762454AbZEGRv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760996AbZEGRuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 13:50:52 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:44408 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754421AbZEGRut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 13:50:49 -0400
Date: Thu, 7 May 2009 13:40:01 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Alok Kataria <akataria@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] x86: Reduce the default HZ value
In-Reply-To: <1241717982.6311.1562.camel@laptop>
Message-ID: <alpine.DEB.1.10.0905071336430.22107@qirst.com>
References: <1241462661.412.8.camel@alok-dev1>  <4A00ADDE.9000908@zytor.com>  <1241560625.8665.17.camel@alok-dev1>  <alpine.DEB.1.10.0905071010170.24528@qirst.com>  <1241716053.6311.1514.camel@laptop>  <1241716422.6311.1524.camel@laptop> 
 <1241716718.6311.1531.camel@laptop>  <alpine.DEB.1.10.0905071320010.22107@qirst.com> <1241717982.6311.1562.camel@laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Peter Zijlstra wrote:

> On Thu, 2009-05-07 at 13:20 -0400, Christoph Lameter wrote:
> > On Thu, 7 May 2009, Peter Zijlstra wrote:
> >
> > > Another user is RCU, the grace period is tick driven, growing these
> > > ticks by a factor 50 or so might require some tinkering with forced
> > > grace periods when we notice our batch queues getting too long.
> >
> > One could also schedule RCU via hrtimers with a large fuzz period?
>
> No, that's not the point, the longer these period are, the more
> callbacks you can accumulate in a period. You need a cap on the callback
> list, we already have seen DoS scenarios in this space.

At some point the RCU must run and if the callback list gets too long the
callbacks must be processed. Thats unavoidable.


