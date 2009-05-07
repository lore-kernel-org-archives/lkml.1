Return-Path: <linux-kernel-owner+w=401wt.eu-S1762321AbZEGRkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762321AbZEGRkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbZEGRkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 13:40:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:33411 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbZEGRkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 13:40:35 -0400
Subject: Re: [PATCH] x86: Reduce the default HZ value
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Alok Kataria <akataria@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <alpine.DEB.1.10.0905071320010.22107@qirst.com>
References: <1241462661.412.8.camel@alok-dev1>  <4A00ADDE.9000908@zytor.com>
	 <1241560625.8665.17.camel@alok-dev1>
	 <alpine.DEB.1.10.0905071010170.24528@qirst.com>
	 <1241716053.6311.1514.camel@laptop>  <1241716422.6311.1524.camel@laptop>
	 <1241716718.6311.1531.camel@laptop>
	 <alpine.DEB.1.10.0905071320010.22107@qirst.com>
Content-Type: text/plain
Date: Thu, 07 May 2009 19:39:42 +0200
Message-Id: <1241717982.6311.1562.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-07 at 13:20 -0400, Christoph Lameter wrote:
> On Thu, 7 May 2009, Peter Zijlstra wrote:
> 
> > Another user is RCU, the grace period is tick driven, growing these
> > ticks by a factor 50 or so might require some tinkering with forced
> > grace periods when we notice our batch queues getting too long.
> 
> One could also schedule RCU via hrtimers with a large fuzz period?

No, that's not the point, the longer these period are, the more
callbacks you can accumulate in a period. You need a cap on the callback
list, we already have seen DoS scenarios in this space.



