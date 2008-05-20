Return-Path: <linux-kernel-owner+w=401wt.eu-S933759AbYETWxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933759AbYETWxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756997AbYETWxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:53:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42043
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753656AbYETWxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:53:31 -0400
Date: Tue, 20 May 2008 15:53:26 -0700 (PDT)
Message-Id: <20080520.155326.195407196.davem@davemloft.net>
To: scottwood@freescale.com
Cc: alan@lxorguk.ukuu.org.uk, tpiepho@freescale.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
From: David Miller <davem@davemloft.net>
In-Reply-To: <4833542E.3040608@freescale.com>
References: <4833524C.3040207@freescale.com>
	<20080520.153947.84346222.davem@davemloft.net>
	<4833542E.3040608@freescale.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott Wood <scottwood@freescale.com>
Date: Tue, 20 May 2008 17:43:58 -0500

> David Miller wrote:
> > The __volatile__ in the asm construct disallows movement of the
> > inline asm relative to statements surrounding it.
> > 
> > The only reason barrier() in kernel.h needs a memory clobber is
> > because of a bug in ancient versions of gcc.  In fact, I think
> > that memory clobber might even be removable.
> 
> Current versions of GCC seem quite happy to move non-asm memory accesses 
> around a volatile asm without a memory clobber; see the test Trent posted.

Indeed, and even the GCC manual is clear about this.
