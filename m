Return-Path: <linux-kernel-owner+w=401wt.eu-S1761044AbYEXSur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761044AbYEXSur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 14:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbYEXSuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 14:50:37 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:57114 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024AbYEXSuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 14:50:37 -0400
Date: Sat, 24 May 2008 20:51:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steve French <smfrench@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
Message-ID: <20080524185114.GA26479@uranus.ravnborg.org>
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com> <48374D3F.1080502@zytor.com> <20080524054301.GA3773@uranus.ravnborg.org> <4837AAE2.9090102@zytor.com> <20080524064201.GA4133@uranus.ravnborg.org> <4837E89D.9040008@goop.org> <20080524112704.GA7292@uranus.ravnborg.org> <483827CE.9080200@goop.org> <20080524153611.GA13890@uranus.ravnborg.org> <48383830.6060504@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48383830.6060504@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 04:45:52PM +0100, Jeremy Fitzhardinge wrote:
> Sam Ravnborg wrote:
> >We should actually do as you intially suggested and alwyas
> >define CONFIG_FOO no matter if FOO is built-in or module.
> >Because we do only want to distingush between the two in rare cases.
> >
> >But that is a separate patch and lets not do the same
> >mistage with CFG_*
> >  
> 
> I think pretty strongly that CFG_ and CONFIG_ should be exactly 
> parallel.  If you want to change the meaning of CONFIG_X in the presence 
> of modules, then change CFG_X at the same time.  Making them have 
> different meanings will just confuse anyone wanting to convert #ifdef 
> CONFIG_ code into if(CFG_) code.

We agree they should have the same semantics - we do just not agree on
the timing.
I would love to do a two patch set:
1) Introduce CFG_
2) Alwyas define CONFIG_FOO in case of modules

But I ned someone to audit the use of CONFIG_FOO before I do
such a change. 
I could just do it - but I'm pretty sure it will hurt.
And I do not want to introduce CFG_ with the same
IMO wrong semantic.

> >We may use CFG_* here and there and clash is not good.
And this needs to be checked too - but this is almost trivial to do.

> I have to say I'm not very keen on the CFG_* prefix.  It doesn't have 
> any inherent meaning and just looks like a redundant abbreviation of 
> CONFIG_; something which actually expresses the notion that it's always 
> a compile-time constant would be better.  Not that I have any 
> particularly good alternatives: CONST_? CCONST_? CONFIG_X_VAL? KCONFIG_? 
> KONFIG_? KCONST_?
Of the above I would prefer KCONFIG_FOO if we do not go for
the CFG_FOO version.
That it is const is already given by being UPPERCASE.

	Sam
