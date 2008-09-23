Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbYIWFc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbYIWFc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 01:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYIWFcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 01:32:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:57276 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783AbYIWFcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 01:32:47 -0400
Subject: Re: PTE access rules & abstraction
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Nick Piggin <npiggin@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20080923031037.GA11907@wotan.suse.de>
References: <1221846139.8077.25.camel@pasglop> <48D739B2.1050202@goop.org>
	 <1222117551.12085.39.camel@pasglop>  <20080923031037.GA11907@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 15:31:26 +1000
Message-Id: <1222147886.12085.93.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-23 at 05:10 +0200, Nick Piggin wrote:
> We are getting better slowly I think (eg. you note that set_pte_at is
> no longer used as a generic "do anything"), but I won't dispute that
> this whole area could use an overhaul; a document for all the rules,
> a single person or point of responsibility for those rules...

Can we nowadays -rely- on set_pte_at() never being called to overwrite
an already valid PTE ? I mean, it looks like the generic code doesn't do
it anymore but I wonder if it's reasonable to forbid that from coming
back ? That would allow me to remove some hacks in ppc64 and simplify
some upcoming ppc32 code.

Cheers,
Ben.


