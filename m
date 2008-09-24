Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbYIXWVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbYIXWVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYIXWVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:21:35 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:48193 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbYIXWVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:21:34 -0400
Subject: Re: PTE access rules & abstraction
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Hugh Dickins <hugh@veritas.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <Pine.LNX.4.64.0809241919520.575@blonde.site>
References: <1221846139.8077.25.camel@pasglop>  <48D739B2.1050202@goop.org>
	 <1222117551.12085.39.camel@pasglop>
	 <Pine.LNX.4.64.0809241919520.575@blonde.site>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 25 Sep 2008 00:17:00 +0200
Message-Id: <1222294620.5968.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-24 at 19:45 +0100, Hugh Dickins wrote:
> > I know s390 has different issues & constraints. Martin told me during
> > Plumbers that mprotect was probably also broken for him.
> 
> Then I hope he will probably send Linus the fix.
> 
> Though what we already have falls somewhat short of perfection,
> I've much more enthusiasm for fixing its bugs, than for any fancy
> redesign introducing its own bugs.  Others have more stamina!

As far as I can tell the current code should work. It is not pretty
though, in particular the nasty pairing of flush_tlb_mm() with
ptep_set_wrprotect() and flush_tlb_range() with change_protection() is
fragile. For me the question is if we can find a sensible set of basic
primitives that work for all architectures in a performant way. This is
really hard..

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


