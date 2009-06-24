Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZFXXhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZFXXhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZFXXhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:37:08 -0400
Received: from outbound-mail-318.bluehost.com ([67.222.54.250]:46336 "HELO
	outbound-mail-318.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752308AbZFXXhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:37:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Yxh1Lm3vODL1Ituk8sWPxNNotJngvqS/wjDUzX64QUo6/VAr8d5i7AS/Ed8XfBwmtXMOAsAzjeRiJqn8Fxy1j0KfvimSdTUmI5cxKESUePoFnomKHVVspu+FcJtr4sTP;
Date: Wed, 24 Jun 2009 16:37:05 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] x86/pci: don't use crs for root if we only have one
 root bus
Message-ID: <20090624163705.0389c8f0@jbarnes-g45>
In-Reply-To: <alpine.LFD.2.01.0906241615160.18460@localhost.localdomain>
References: <20090624122433.GA24781@elte.hu>
	<20090624145119.GA12664@elte.hu>
	<4A429EBB.5010209@kernel.org>
	<4A42AFAC.6000300@kernel.org>
	<alpine.LFD.2.01.0906241607100.18460@localhost.localdomain>
	<alpine.LFD.2.01.0906241615160.18460@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 16:21:09 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 24 Jun 2009, Linus Torvalds wrote:
> >
> > I'm happy to apply various patches to fix it up, but regardless, I
> > thinkwe should revert that commit as bogus. We can try making it
> > the default again next round, when maybe it will be true that it
> > doesn't cause issues.
> 
> Btw, I really think our _CRS handling sucks.
> 
> There's two things that you can do with _CRS:
> 
>  - use the _existence_ of it as an indicator of a root bus
> 
>  - try to use it to populate the resource tree.
> 
> And quite frankly, I think #2 is broken. There's no way in hell that
> ACPI tables are ever going to be better than just asking the
> hardware. We've gone through this before. Trusting ACPI over the
> hardware is just FUNDAMENTALLY WRONG.
> 
> So I'm just going to do that revert. I'm not sure if it ever makes
> sense to make that insane _CRS code the default. It seems like a
> fundamentally flawed idea.

Yeah, I think it's reasonable to revert, especially given how we do
_CRS handling currently.  I'm hoping at some point we can use the _CRS
data to at least augment the configuration we get from hardware, since
on some machines it seems to be necessary.

-- 
Jesse Barnes, Intel Open Source Technology Center
