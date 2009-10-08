Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbZJHNMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbZJHNMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 09:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbZJHNMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 09:12:47 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:50148 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100AbZJHNMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 09:12:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SOY7wZdRV4FZunYXjZAAO6m7OK/urFL/ZXZuse7W/SvDfbDFQytl5B21XGhGaSm3G7
         zs68S8ctlk17wbyz5mJE2X6DUHyCKF/ajcaPljAWzLpffXwrpYoIo1351ir91HfP364o
         Zrm4R70Ly/Uepgy9XmhZePhzzZ/dJEnBfOfEc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0910071450510.3432@localhost.localdomain>
References: <20091006101414.GM5216@kernel.dk>
	 <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain>
	 <alpine.LFD.2.01.0910070911080.3432@localhost.localdomain>
	 <20091007164622.GX30316@wotan.suse.de>
	 <alpine.LFD.2.01.0910071222230.3432@localhost.localdomain>
	 <87eipfymcv.fsf@basil.nowhere.org>
	 <alpine.LFD.2.01.0910071349190.3432@localhost.localdomain>
	 <20091007210651.GB1656@one.firstfloor.org>
	 <alpine.LFD.2.01.0910071417300.3432@localhost.localdomain>
	 <alpine.LFD.2.01.0910071450510.3432@localhost.localdomain>
Date: Thu, 8 Oct 2009 15:12:08 +0200
Message-ID: <1158166a0910080612h29d93d50y875d5305cd4d985f@mail.gmail.com>
Subject: Re: [rfc][patch] store-free path walking
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 11:57 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> This, btw, is exactly the kind of thing we saw with some of the
> non-temporal work, when we used nontemporal stores to copy pages on COW
> faults, or when doing pre-zeroing of pages. You get rid of some of the
> hot-spots in the kernel, and you then replace them with user space taking
> the cache misses in random spots instead. The kernel profile looks better,
> and system time may go down, but actual performace never went down - you
> just moved your cache miss cost from one place to another.

A few years ago when K7s were not ancient yet, after hearing
argument for and against non-temporal stores,
I decided to finally figure it for myself.

I tested kernel build workload on two kernels with the only
one difference - clear_page with and without non-temporal stores.

"Non-temporal stores" kernel was faster, not slower. Just a little bit,
but reproducibly.
--
vda
