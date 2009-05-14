Return-Path: <linux-kernel-owner+w=401wt.eu-S1761579AbZENNBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761579AbZENNBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760005AbZENNB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:01:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759921AbZENNBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:01:25 -0400
Subject: Re: [PATCH 0/4] x86-64: fix vclock_gettime()
From: Petr Tesarik <ptesarik@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-x86_64@vger.kernel.org, mingo@elte.hu,
       zwane@arm.linux.org.uk
In-Reply-To: <20090514125825.GA10933@one.firstfloor.org>
References: <cover.1242299014.git.ptesarik@suse.cz>
	 <20090514125825.GA10933@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Thu, 14 May 2009 15:01:25 +0200
Message-Id: <1242306085.19219.2.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen píše v Čt 14. 05. 2009 v 14:58 +0200:
> > To rectify the situation, I saw the following options:
> > 
> >  1. Adjust pointers in the vDSO .altinstruction section during
> >     vDSO setup, and then pass it to apply_alternatives()
> >  2. List the relocations with objdump and add them again to vdso.S
> >     using the .reloc GAS directive
> >  3. Link the vDSO into the kernel with relocations, i.e. not just
> >     as a blob
> 
> 4. Just move the barriers back back into the main kernel.

Sorry, this doesn't work, because the function is inlined. And even if
it wasn't, the vDSO must be self-contained by definition. User-space
cannot simply call into kernel-space.

Cheers,
Petr Tesarik


