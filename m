Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbXCIAHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbXCIAHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbXCIAHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:07:17 -0500
Received: from kepler.fjfi.cvut.cz ([147.32.6.11]:35092 "EHLO
	kepler.fjfi.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbXCIAHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:07:16 -0500
Date: Fri, 9 Mar 2007 01:07:04 +0100 (CET)
From: Martin Drab <drab@kepler.fjfi.cvut.cz>
To: Carsten Otte <cotte.de@gmail.com>
cc: hugh@veritas.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question about memory mapping mechanism
In-Reply-To: <Pine.LNX.4.64.0703082143370.25365@kepler.fjfi.cvut.cz>
Message-ID: <Pine.LNX.4.64.0703090103020.25365@kepler.fjfi.cvut.cz>
References: <Pine.LNX.4.64.0703081345010.21317@kepler.fjfi.cvut.cz>
 <5c77e7070703080617r63cbccfevd2c6d678f16c2b03@mail.gmail.com>
 <Pine.LNX.4.64.0703082143370.25365@kepler.fjfi.cvut.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007, Martin Drab wrote:

> On Thu, 8 Mar 2007, Carsten Otte wrote:
> 
> > On 3/8/07, Martin Drab <drab@kepler.fjfi.cvut.cz> wrote:
> > > 
> > > The thing is that I'd like to prevent kernel to swap these pages out,
> > > because then I may loose some data when they are not available in time
> > > for the next round.
> > 
> > One think you could do is grab a reference to the pages upfront.
> 
> I'm not really sure what exactly do you mean by "grab a reference 
> upfront"?

I seem to get it now. So instead of setting PG_reserved upon allocation of 
the buffer pages, I should increase the referrence of the pages by calling 
get_page() on them and that would prevent the pages to get on the lru list 
and thus preventing them to be swapped out. Is that it?

Martin
