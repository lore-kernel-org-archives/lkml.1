Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbYLFFpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbYLFFpZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 00:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbYLFFpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 00:45:07 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:50298 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbYLFFpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 00:45:06 -0500
Date: Sat, 6 Dec 2008 11:14:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: penberg@cs.helsinki.fi, jdike@addtoit.com, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, stable@kernel.org
Subject: Re: [PATCH][UML] Boot broken due to buffer overrun
Message-ID: <20081206054459.GB7582@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	penberg@cs.helsinki.fi, jdike@addtoit.com,
	linux-kernel@vger.kernel.org,
	user-mode-linux-devel@lists.sourceforge.net, stable@kernel.org
References: <20081129100830.GA24128@balbir.in.ibm.com> <84144f020811290221g947f836n4fe3435676425ee@mail.gmail.com> <20081129122039.GA31635@balbir.in.ibm.com> <20081202121707.e1623f89.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081202121707.e1623f89.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2008-12-02 12:17:07]:

> On Sat, 29 Nov 2008 17:50:39 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * Pekka Enberg <penberg@cs.helsinki.fi> [2008-11-29 12:21:46]:
> > 
> > > Hi Balbir,
> > > 
> > > On Sat, Nov 29, 2008 at 12:08 PM, Balbir Singh
> > > <balbir@linux.vnet.ibm.com> wrote:
> > > > mconsole_init() passed 256 bytes as length in os_create_unix_socket, while
> > > > the sizeof UNIX_PATH_MAX is 108. This patch fixes that problem and avoids
> > > > a big overrun bug reported on UML bootup.
> > > 
> > > Maybe mention that ->sun_path in struct sockaddr_un is UNIX_PATH_MAX
> > > long which causes the problem?
> > >
> > 
> > Yes, the changelog can definitely add that to the changelog, I'll
> > resend the patch if Jeff asks for it.
> 
> Jeff's been quiet lately - I'll merge this one.
> 

Thanks!

> I also tagged it for -stable, subject to Jeff's OK.  I'm wondering why
> this wasn't observed in earlier kernels?
> 

I observed it with the newer toolchain that uses __USE_FORTIFY_LEVEL
and __FORTIFY_SOURCE


-- 
	Balbir
