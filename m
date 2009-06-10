Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbZFJLzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbZFJLzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 07:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758293AbZFJLza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 07:55:30 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:46550 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757273AbZFJLz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 07:55:29 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] X86: cpu_debug support for VIA / Centaur CPU's
Date: Wed, 10 Jun 2009 06:55:27 -0500
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@kernel.org>, Harald Welte <HaraldWelte@viatech.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
References: <20090609082931.GD25316@prithivi.gnumonks.org> <200906100611.14941.lkml@morethan.org> <20090610111352.GA4482@elte.hu>
In-Reply-To: <20090610111352.GA4482@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906100655.29833.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed June 10 2009, Ingo Molnar wrote:
> 
> * Michael S. Zick <lkml@morethan.org> wrote:
> 
> > On Wed June 10 2009, Ingo Molnar wrote:
> > > 
> > > * H. Peter Anvin <hpa@kernel.org> wrote:
> > > 
> > > > Ingo Molnar wrote:
> > > > > 
> > > > > MSRs should really be enumerated along CPU features. They will be 
> > > > > accessed if a CPU offers that CPU feature.
> > > > > 
> > > > 
> > > > Nice in theory, but so many MSRs have to be enumerated with obscure test
> > > > combinations, that it really isn't practical in the general case.  That
> > > > is why we have the safe MSR variants.
> > > > 
> > > > > 
> > > > > Yeah, the safe read should never fault - there should be all 
> > > > > zeroes or an error return.
> > > > > 
> > > > 
> > > > Error return, MSRs #GP if not present.  All zero means a present 
> > > > MSR (which is zero.)
> > > 
> > > yes, of course - i meant the /debug/x86/cpu/* behavior: it should 
> > > either result zeroes, or should return -EINVAL. (probably the 
> > > latter)
> > > 
> > 
> > Return zeroes - same as hardware case for bits which can't be set. 
> > Returning -EINVAL might match a specific bit pattern caller is 
> > looking for.
> 
> these files are accessed via read(). The -EINVAL is the syscall 
> return value. The value (if any) goes into the buffer that is being 
> read into. So there's no way to 'match a specific bit pattern' - 
> it's two separate spaces.
> 

Right.  Prior post was just a bad case of nerves.  ;)

Mike
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


