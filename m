Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbXIRAGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbXIRAGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 20:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbXIRAGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 20:06:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36900 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648AbXIRAGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 20:06:12 -0400
Date: Tue, 18 Sep 2007 05:38:57 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Paul Mackerras <paulus@samba.org>
cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc: Avoid pointless WARN_ON(irqs_disabled()) from
 panic codepath
In-Reply-To: <alpine.LFD.0.999.0709180511070.8863@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0709180535470.8863@enigma.security.iitk.ac.in>
References: <46EA5CEB.7020104@linux.vnet.ibm.com>
 <a781481a0709140337u2c26f770h2af6d457bc39f280@mail.gmail.com>
 <alpine.LFD.0.999.0709180511070.8863@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Sep 2007, Satyam Sharma wrote:
> 
> > ------------[ cut here ]------------
> > Badness at arch/powerpc/kernel/smp.c:202
> 
> comes when smp_call_function_map() has been called with irqs disabled,
> which is illegal. However, there is a special case, the panic() codepath,
> when we do not want to warn about this -- warning at that time is pointless
> anyway, and only serves to scroll away the *real* cause of the panic and
> distracts from the real bug.

BTW arch/ppc/ has same issue, but that's gonna be removed by next year
anyways, so I think there's no point making a patch for that (?)
