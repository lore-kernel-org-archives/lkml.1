Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbYEXL0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbYEXL0f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 07:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbYEXL00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 07:26:26 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:33126 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbYEXL0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 07:26:25 -0400
Date: Sat, 24 May 2008 13:27:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steve French <smfrench@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
Message-ID: <20080524112704.GA7292@uranus.ravnborg.org>
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com> <48374D3F.1080502@zytor.com> <20080524054301.GA3773@uranus.ravnborg.org> <4837AAE2.9090102@zytor.com> <20080524064201.GA4133@uranus.ravnborg.org> <4837E89D.9040008@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4837E89D.9040008@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 11:06:21AM +0100, Jeremy Fitzhardinge wrote:
> Sam Ravnborg wrote:
> >On Fri, May 23, 2008 at 10:42:58PM -0700, H. Peter Anvin wrote:
> >  
> >>Sam Ravnborg wrote:
> >>    
> >>>>*However*, the best would really be if we changed Kconfig to emit 
> >>>>configuration constants what were 0/1 instead of undefined/defined. 
> >>>>That way we could do:
> >>>>
> >>>>	if (CONFIG_SOMETHING && foo) {
> >>>>		/* ... something ... */
> >>>>	} else if ((mode & S_IWUGO) == 0) {
> >>>>		/* ... */
> >>>>        
> >>>We could do that - but then it would need another
> >>>name not to clash with all the places where we rely
> >>>on CONFIG_FOO='n' => CONFIG_FOO is not defined.
> >>>
> >>>We could teach kconfig to emit something like:
> >>>#define KFOO 0   (for the 'n' value)
> >>>And 1 or 2 for the y and m values.
> >>>
> >>>      
> >>I don't think we want to use "1 or 2"... I suspect we want to use the 
> >>same booleans we currently have.
> >>    
> >I'm a bit dense (or I need more coffe - it's morning here).
> >What "same booleans"?
> >  
> 
> They should be plain 0/1 booleans.  For a bool/tristate option FOO, it 
> would define:
> 
> Enabled y:
> 
>    #define CONFIG_FOO
>    #define CFG_FOO   1
>    #undef CONFIG_FOO_MODULE
>    #define CFG_FOO_MODULE 0
Agreed

> 
> Enabled m:
> 
>    #define CONFIG_FOO
>    #define CFG_FOO   1
>    #define CONFIG_FOO_MODULE
>    #define CFG_FOO_MODULE 1

I assume you wanted to say:
>    #undef  CONFIG_FOO
>    #define CFG_FOO   1
>    #define CONFIG_FOO_MODULE
>    #define CFG_FOO_MODULE 1
Because then the CONFIG_* is not changed
and we do not want to change that.

I'm not fully convinced about:
>    #define CFG_FOO   1
But on the other hand it is only in odd
cases we distingush between built-in and module.
So it makes most sense.

> Disabled n:
> 
>    #undef CONFIG_FOO
>    #define CFG_FOO   0
>    #undef CONFIG_FOO_MODULE
>    #define CFG_FOO_MODULE 0
Agree.

> 
> Not sure what CFG_* should be for string/numeric options.  Probably "1" 
> if the value is defined, "0" if not, with CONFIG_* being the actual 
> value (so a CONFIG_ value of 0 is distinguishable from not defined).
For non-boolean/tristate values we simply skip CFG_ values - thats
the most simple approach.

	Sam
