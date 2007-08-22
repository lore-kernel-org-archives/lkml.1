Return-Path: <linux-kernel-owner+w=401wt.eu-S1763218AbXHVOi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763218AbXHVOi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 10:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761364AbXHVOiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 10:38:14 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:50796 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760432AbXHVOiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 10:38:05 -0400
Subject: Re: [2.6.20.17 review 00/58] 2.6.20.17 -stable review
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: James Morris <jmorris@namei.org>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <6bffcb0e0708220729j7b9afcf3v4edef68cc974c08d@mail.gmail.com>
References: <20070822083844.%N@1wt.eu>
	 <6bffcb0e0708220410u4ab3978eq18786ac186e88c7d@mail.gmail.com>
	 <Xine.LNX.4.64.0708220621550.28878@us.intercode.com.au>
	 <1187789765.1451.310.camel@moss-spartans.epoch.ncsc.mil>
	 <1187790174.1451.315.camel@moss-spartans.epoch.ncsc.mil>
	 <Xine.LNX.4.64.0708220707390.9414@us.intercode.com.au>
	 <6bffcb0e0708220729j7b9afcf3v4edef68cc974c08d@mail.gmail.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 22 Aug 2007 10:32:18 -0400
Message-Id: <1187793138.1451.349.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-22 at 16:29 +0200, Michal Piotrowski wrote:
> On 22/08/07, James Morris <jmorris@namei.org> wrote:
> > On Wed, 22 Aug 2007, Stephen Smalley wrote:
> >
> > > Oops, never mind - tail still follows secmark, so that shouldn't matter.
> > > So I'm not sure why we are getting a bad value for secmark here - should
> > > be initialized to zero and never modified unless there is an iptables
> > > secmark rule.
> >
> > Michal, do you see this in current git?
> 
> No, I do not see this problem in 2.6.23. I had similar problem last
> month, but it is fixed now.
> 
> http://lkml.org/lkml/2007/7/12/362

The difference being that there the denials were against unlabeled_t
(the expected default in the presence of no iptables SECMARK rules, and
allowed by current policies), while the denials against 2.6.20.17 were
against kernel_t.  Which shouldn't ever happen unless you have an
iptables SECMARK rule that assigns that value to a packet.  So this is a
different issue.  BTW, the fact that it is showing up as kernel_t means
that skb->secmark == SECINITSID_KERNEL == 1, FWIW.  Whereas it should be
zero in the absence of iptables rules that set it.

-- 
Stephen Smalley
National Security Agency

