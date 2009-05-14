Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbZENO1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbZENO1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 10:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbZENO1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 10:27:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbZENO1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 10:27:40 -0400
Subject: Re: [PATCH 0/4] x86-64: fix vclock_gettime()
From: Petr Tesarik <ptesarik@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-x86_64@vger.kernel.org, mingo@elte.hu,
       zwane@arm.linux.org.uk
In-Reply-To: <20090514140247.GC10933@one.firstfloor.org>
References: <cover.1242299014.git.ptesarik@suse.cz>
	 <20090514125825.GA10933@one.firstfloor.org>
	 <1242306085.19219.2.camel@nathan.suse.cz>
	 <20090514140247.GC10933@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Thu, 14 May 2009 16:27:40 +0200
Message-Id: <1242311260.19219.22.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen píše v Čt 14. 05. 2009 v 16:02 +0200:
> > Sorry, this doesn't work, because the function is inlined. And even if
> > it wasn't, the vDSO must be self-contained by definition. User-space
> > cannot simply call into kernel-space.
> 
> Wrong, it can call into vsyscall space.

Ah, yes, you're right. The vsyscall is always mapped and it is a special
case for the instruction replacement code already.

So, is there any reason not to put the rdtsc_barrier() around
vget_cycles() in vread_tsc() ?

Petr Tesarik


