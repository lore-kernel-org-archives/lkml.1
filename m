Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbZINIKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbZINIKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 04:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbZINIKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 04:10:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56022 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbZINIKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 04:10:15 -0400
Date: Mon, 14 Sep 2009 09:10:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jamie Lokier <jamie@shareable.org>
Cc: Marek Vasut <marek.vasut@gmail.com>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: remove unused code in delay.S
Message-ID: <20090914081001.GB14519@n2100.arm.linux.org.uk>
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com> <200909132328.47079.marek.vasut@gmail.com> <20090913230008.GC30169@n2100.arm.linux.org.uk> <20090914002100.GD30621@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914002100.GD30621@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 01:21:00AM +0100, Jamie Lokier wrote:
> Russell King - ARM Linux wrote:
> > On Sun, Sep 13, 2009 at 11:28:47PM +0200, Marek Vasut wrote:
> > > >  		bhi	__delay
> > > >  		mov	pc, lr
> > > >  ENDPROC(__udelay)
> > > > 
> > > Hi
> > > 
> > > why was this code there in the first place ?
> > 
> > To make the delay loop more stable and predictable on older CPUs.
> 
> So why has it been commented out, if it's needed for that?

We moved on and it penalises later CPUs, leading to udelay providing
shorter delays than requested.

So the choice was either stable and predictable on older CPUs but
buggy on newer CPUs, or correct on all CPUs but gives unnecessarily
longer delays on older CPUs.
