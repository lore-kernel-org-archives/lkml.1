Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbXF1ERR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbXF1ERR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 00:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbXF1ERG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 00:17:06 -0400
Received: from terminus.zytor.com ([192.83.249.54]:55601 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbXF1ERF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 00:17:05 -0400
Message-ID: <468332D3.4040707@zytor.com>
Date: Thu, 28 Jun 2007 00:02:27 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: Adrian Bunk <bunk@stusta.de>, David Woodhouse <dwmw2@infradead.org>,
       Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, david@lang.hm,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux Kernel include files
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de> <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm> <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de> <1182483527.10524.31.camel@shinybook.infradead.org> <20070622150038.GN23017@stusta.de> <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com>
In-Reply-To: <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> 
> Gah, this particular topic and a few other similar header-compatibility 
> ones show up once a month on LKML; I should probably just make a patch 
> to fix all the types.h files and be done with it.  The proper solution 
> is this:
> 
> # if __STDC_VERSION__ >= 19901L
> typedef   signed long long __s64;
> typedef unsigned long long __u64;
> # elif defined(__GNUC__)
> __extension__ typedef   signed long long __s64;
> __extension__ typedef unsigned long long __u64;
> # else
> #  error "Your compiler doesn't support long long (IOW: It sucks).  
> Please get a new one"
> # endif
> 
> That way if you have any kind of vaguely-long-long-compatible compiler 
> then it will work, and otherwise you'll get a nice useful error 
> message.  It also makes sure that GCC doesn't spew warnings/errors when 
> in c89-pedantic mode.  The "__extension__" keyword is designed for use 
> in implementation header files which want to use GCC-isms unconditionally.
> 

__extension__ should be macroized if so.

However, since something that doesn't have "long long" won't be able to 
compile those headers, there is absolutely no reason to not simply use 
it -- you get an error message on that line, which is good enough. 
There is definitely no reason to use a test like the one above, which is 
wrong for several supportable compilers.

	-hpa

