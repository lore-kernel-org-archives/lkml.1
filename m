Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbZFXXzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbZFXXzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZFXXzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:55:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752095AbZFXXzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:55:46 -0400
Date: Wed, 24 Jun 2009 16:54:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] x86/pci: don't use crs for root if we only have one root
 bus
In-Reply-To: <20090624163705.0389c8f0@jbarnes-g45>
Message-ID: <alpine.LFD.2.01.0906241645300.3605@localhost.localdomain>
References: <20090624122433.GA24781@elte.hu> <20090624145119.GA12664@elte.hu> <4A429EBB.5010209@kernel.org> <4A42AFAC.6000300@kernel.org> <alpine.LFD.2.01.0906241607100.18460@localhost.localdomain> <alpine.LFD.2.01.0906241615160.18460@localhost.localdomain>
 <20090624163705.0389c8f0@jbarnes-g45>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Jun 2009, Jesse Barnes wrote:
> 
> Yeah, I think it's reasonable to revert, especially given how we do
> _CRS handling currently.  I'm hoping at some point we can use the _CRS
> data to at least augment the configuration we get from hardware, since
> on some machines it seems to be necessary.

Agreed. I do think we should take _CRS into account - possibly just as a 
minimal hint to determine which root buses to try to scan (maybe we do 
this already, I really didn't check). Or maybe we could use it to extend 
on our scan information.

But when it seems to have things like "this bus can forward VGA cycles" 
kind of "resources" (which seems to be the main reason Larry Finger has so 
many of them), then that's just worthless knowledge that we're much better 
off just determining on our own.

Anyway, I may feel pretty strongly about things like this, but I'm also 
open to being convinced otherwise for 2.6.32. I wanted to do -rc1 today 
(it's been more than two weeks), and while I don't expect -rc1 to be 
flawless, I also hate to release it with _known_ bugs.

So partly due to timing, I'd rather revert it, and we can revisit it for 
the next release - whatever the actual end result then will be.

[ There's a difference between "we're supposed to find and fix bugs in the 
  -rc series", and "I release known-buggy -rc1's since we're supposed to 
  fix it later". For similar reasons, I hate pulling known-buggy stuff 
  during the merge window - it's ok if it shows itself to be buggy 
  _later_, but if people send me stuff that they know is buggy as they 
  send it to me, then that's a problem. ]

		Linus
