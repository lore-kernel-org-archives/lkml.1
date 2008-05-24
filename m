Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbYEXP5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbYEXP5h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYEXP51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:57:27 -0400
Received: from po-out-1718.google.com ([72.14.252.154]:4595 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYEXP50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:57:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N2OnvNcZ915cSAg7kcAVBgRp2k2MHF1GWsYd7tpd8mT4WjH4o592NyuiQfF83toP6H+v9ZOFAg6td3MxEBL0jZbsv/66b8qy+1tFIMdArQG9119omdjPtTQmdcaDa0MJPoqV93duENcCFO0UYud6PS+XK4AWJ87GLSx6gODsnZA=
Message-ID: <19f34abd0805240857l57e667fdicb240baf898f6296@mail.gmail.com>
Date: Sat, 24 May 2008 17:57:25 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Steve French" <smfrench@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <48383830.6060504@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com>
	 <48374D3F.1080502@zytor.com>
	 <20080524054301.GA3773@uranus.ravnborg.org>
	 <4837AAE2.9090102@zytor.com>
	 <20080524064201.GA4133@uranus.ravnborg.org>
	 <4837E89D.9040008@goop.org>
	 <20080524112704.GA7292@uranus.ravnborg.org>
	 <483827CE.9080200@goop.org>
	 <20080524153611.GA13890@uranus.ravnborg.org>
	 <48383830.6060504@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 5:45 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Sam Ravnborg wrote:
>>
>> We should actually do as you intially suggested and alwyas
>> define CONFIG_FOO no matter if FOO is built-in or module.
>> Because we do only want to distingush between the two in rare cases.
>>
>> But that is a separate patch and lets not do the same
>> mistage with CFG_*
>>
>
> I think pretty strongly that CFG_ and CONFIG_ should be exactly parallel.
>  If you want to change the meaning of CONFIG_X in the presence of modules,
> then change CFG_X at the same time.  Making them have different meanings
> will just confuse anyone wanting to convert #ifdef CONFIG_ code into
> if(CFG_) code.
>
>> I cooked up following patch - but I have not test-build a kernel yet.
>> We may use CFG_* here and there and clash is not good.
>>
>
> I have to say I'm not very keen on the CFG_* prefix.  It doesn't have any
> inherent meaning and just looks like a redundant abbreviation of CONFIG_;
> something which actually expresses the notion that it's always a
> compile-time constant would be better.  Not that I have any particularly
> good alternatives: CONST_? CCONST_? CONFIG_X_VAL? KCONFIG_? KONFIG_?
> KCONST_?

Don't know if this is really my place, but I could not agree more with
your characterisation of the CFG_* prefix and I will make the
following suggestion:

Why not use all-lowercase config_* names? It seems elegant, and fits
in with the notion that these are to be used not as macros, but as
ordinary constants.

(The only disadvantage I can see is that they will stand out less. But
I don't know how great the disadvantage is.)

You could even go further and make them real constants, something
along the lines of:

enum config_value { no, yes, mod };

static const enum config_value config_lockdep_support = yes;

(I believe the "static const" will prevent emission of this symbol in
the object file -- though I am not certain.)

You can now also test for specific values, e.g. if
(config_scsi_wait_scan == mod), in addition to simply testing the
truth value.

That concludes my suggestion.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
