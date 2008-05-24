Return-Path: <linux-kernel-owner+w=401wt.eu-S1759908AbYEXPqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908AbYEXPqc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbYEXPqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:46:23 -0400
Received: from gw.goop.org ([64.81.55.164]:47433 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816AbYEXPqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:46:22 -0400
Message-ID: <48383830.6060504@goop.org>
Date: Sat, 24 May 2008 16:45:52 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Steve French <smfrench@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com> <48374D3F.1080502@zytor.com> <20080524054301.GA3773@uranus.ravnborg.org> <4837AAE2.9090102@zytor.com> <20080524064201.GA4133@uranus.ravnborg.org> <4837E89D.9040008@goop.org> <20080524112704.GA7292@uranus.ravnborg.org> <483827CE.9080200@goop.org> <20080524153611.GA13890@uranus.ravnborg.org>
In-Reply-To: <20080524153611.GA13890@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> We should actually do as you intially suggested and alwyas
> define CONFIG_FOO no matter if FOO is built-in or module.
> Because we do only want to distingush between the two in rare cases.
>
> But that is a separate patch and lets not do the same
> mistage with CFG_*
>   

I think pretty strongly that CFG_ and CONFIG_ should be exactly 
parallel.  If you want to change the meaning of CONFIG_X in the presence 
of modules, then change CFG_X at the same time.  Making them have 
different meanings will just confuse anyone wanting to convert #ifdef 
CONFIG_ code into if(CFG_) code.

> I cooked up following patch - but I have not test-build a kernel yet.
> We may use CFG_* here and there and clash is not good.
>   

I have to say I'm not very keen on the CFG_* prefix.  It doesn't have 
any inherent meaning and just looks like a redundant abbreviation of 
CONFIG_; something which actually expresses the notion that it's always 
a compile-time constant would be better.  Not that I have any 
particularly good alternatives: CONST_? CCONST_? CONFIG_X_VAL? KCONFIG_? 
KONFIG_? KCONST_?

    J
