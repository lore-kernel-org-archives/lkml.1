Return-Path: <linux-kernel-owner+w=401wt.eu-S1762120AbYEOQth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762120AbYEOQth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 12:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761629AbYEOQt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 12:49:26 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:61274 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759691AbYEOQtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 12:49:25 -0400
Date: Thu, 15 May 2008 11:48:02 -0500
From: Scott Wood <scottwood@freescale.com>
To: David Miller <davem@davemloft.net>
Cc: rostedt@goodmis.org, proski@gnu.org, a.p.zijlstra@chello.nl, pq@iki.fi,
       linux-kernel@vger.kernel.org, srostedt@redhat.com,
       linuxppc-dev@ozlabs.org, sandmann@redhat.com, paulus@samba.org,
       mingo@elte.hu
Subject: Re: [PATCH 2/2] ftrace: support for PowerPC
Message-ID: <20080515164802.GA2664@loki.buserror.net>
References: <20080515034942.109223655@goodmis.org> <20080515035918.896765954@goodmis.org> <20080514.222857.246967279.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514.222857.246967279.davem@davemloft.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 10:28:57PM -0700, David Miller wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Wed, 14 May 2008 23:49:44 -0400
> 
> > +#ifdef CONFIG_FTRACE
> > +#ifdef CONFIG_DYNAMIC_FTRACE
> > +_GLOBAL(mcount)
> > +_GLOBAL(_mcount)
> > +	stwu	r1,-48(r1)
> > +	stw	r3, 12(r1)
> > +	stw	r4, 16(r1)
> > +	stw	r5, 20(r1)
> > +	stw	r6, 24(r1)
> > +	mflr	r3
> > +	stw	r7, 28(r1)
> > +	mfcr	r5
> > +	stw	r8, 32(r1)
> > +	stw	r9, 36(r1)
> > +	stw	r10,40(r1)
> > +	stw	r3, 44(r1)
> > +	stw	r5, 8(r1)
> 
> Yikes, that's really expensive.
> 
> Can't you do a tail call and let the function you end
> up calling do all the callee-saved register pops onto
> the stack?

The PPC32 ABI seems to (unfortunately) suggest that, with mcount, all
registers are callee-saved (except for the modifiable-during-function-linkage
registers like r0, r11, and r12) -- so mcount has to save the registers that
the callee won't (because they're normally volatile).

-Scott
