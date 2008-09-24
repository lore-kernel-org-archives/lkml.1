Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbYIXSrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbYIXSrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYIXSrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:47:14 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:38493 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYIXSrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:47:13 -0400
Date: Wed, 24 Sep 2008 19:45:47 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: PTE access rules & abstraction
In-Reply-To: <1222117551.12085.39.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0809241919520.575@blonde.site>
References: <1221846139.8077.25.camel@pasglop>  <48D739B2.1050202@goop.org>
 <1222117551.12085.39.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008, Benjamin Herrenschmidt wrote:
> 
> The bug may have been there, as I said, lots of unwritten rules...
> sometimes broken. I'm not necessarily blaming you, but there have been
> lots of changes to the PTE accessors over the last 2 years and not
> always under any control :-)
> 
> In our case, the consequence is that the entry can be re-hashed because
> the fact that it was already hashed and where it was hashed, which is
> encoded in the PTE, gets lost by the clear. That means a potential
> duplicate entry in the hash. A hard to hit race, but possible. Such a
> condition is architecturally illegal and can cause things ranging from
> incorrect translation to machine checks or checkstops (generally, on
> LPAR machines, what will happen is your partition will get killed).

The powerpc bug whereof you write appears to have been there since ...
linux-2.4.0 or earlier:
			entry = ptep_get_and_clear(pte);
			set_pte(pte, pte_modify(entry, newprot));

But perhaps powerpc was slightly different back in those days.
It sounds to me like a bug in your current ptep_get_and_clear(),
not checking if already hashed?

> I know s390 has different issues & constraints. Martin told me during
> Plumbers that mprotect was probably also broken for him.

Then I hope he will probably send Linus the fix.

Though what we already have falls somewhat short of perfection,
I've much more enthusiasm for fixing its bugs, than for any fancy
redesign introducing its own bugs.  Others have more stamina!

Hugh
