Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbYE0Pe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbYE0Pe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbYE0Pet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:34:49 -0400
Received: from vena.lwn.net ([206.168.112.25]:48222 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756935AbYE0Pes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:34:48 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 May 2008 11:34:48 EDT
Date: Tue, 27 May 2008 09:28:30 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: benh@kernel.crashing.org
Cc: Linux Arch list <linux-arch@vger.kernel.org>,
       David Miller <davem@davemloft.net>, scottwood@freescale.com,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Trent Piepho <tpiepho@freescale.com>
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080527092830.3535ee7b@bike.lwn.net>
In-Reply-To: <1211852026.3286.36.camel@pasglop>
References: <4833524C.3040207@freescale.com>
	<20080520.153947.84346222.davem@davemloft.net>
	<4833542E.3040608@freescale.com>
	<20080520.155326.195407196.davem@davemloft.net>
	<1211516683.8297.271.camel@pasglop>
	<Pine.LNX.4.64.0805221553400.8205@t2.domain.actdsltmp>
	<1211852026.3286.36.camel@pasglop>
Organization: LWN.net
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 11:33:46 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> However, I'm using that as an excuse to bring back my pet subject,
> which is basically, should we instead just finally mandate the use of
> explicit rmb/wmb/mb's (which boils down to barrier() on x86) to
> drivers who want to order memory consistent accesses vs. MMIO ?

To me this seems like asking for a long series of weird bugs in
drivers.  Is the cost of a barrier in an MMIO operation so high that we
can't afford to just put them in?  Alan's suggestion of no-barrier
versions for people who know what they're doing (and who think there's a
reason to care) seems like a better way to go to me.

jon

