Return-Path: <linux-kernel-owner+w=401wt.eu-S1765592AbYJMKMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765592AbYJMKMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759396AbYJMJzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:55:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:40590 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375AbYJMJzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:55:51 -0400
Subject: Re: [RFC 1/3] hvc_console: rework setup to replace irq functions
	with callbacks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200810131047.12748.borntraeger@de.ibm.com>
References: <200806031444.21945.borntraeger@de.ibm.com>
	 <200810130951.31733.borntraeger@de.ibm.com>
	 <1223886972.8157.241.camel@pasglop>
	 <200810131047.12748.borntraeger@de.ibm.com>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 20:52:59 +1100
Message-Id: <1223891579.8157.251.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-13 at 10:47 +0200, Christian Borntraeger wrote:
> > I will try. Of course the risk here is that the interrupt happens
> > after we set hp->tty to NULL, so we probably need to check within the
> > interrupt handler for a NULL tty. I haven't checked if that's the case
> > (I'm not in front of the code right now).
> 
> Even the old code (without my patch) was setting hp->tty to NULL before doing 
> the irq_free, so that should be ok.

Yup, just checked, it should be allright as long as it's cleared with
the spinlock held, which seems to be the case with your patch. I'll test
your fixup patch tomorrow to see if it clears the lockdep error.

Thanks !

Ben.


