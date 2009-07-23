Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbZGWPIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbZGWPIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 11:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZGWPIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 11:08:10 -0400
Received: from ns2.tasking.nl ([195.193.207.10]:16433 "EHLO ns2.tasking.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZGWPIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 11:08:09 -0400
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
X-Newsreader: knews 1.0b.1
Reply-To: dick.streefland@altium.nl (Dick Streefland)
Organization: Altium BV
X-Face: "`*@3nW;mP[=Z(!`?W;}cn~3M5O_/vMjX&Pe!o7y?xi@;wnA&Tvx&kjv'N\P&&5Xqf{2CaT 9HXfUFg}Y/TT^?G1j26Qr[TZY%v-1A<3?zpTYD5E759Q?lEoR*U1oj[.9\yg_o.~O.$wj:t(B+Q_?D XX57?U,#b,iM$[zX'I(!'VCQM)N)x~knSj>M*@l}y9(tK\rYwdv%~+&*jV"epphm>|q~?ys:g:K#R" 2PuAzy-N9cKM<Ml/%yPQxpq"Ttm{GzBn-*:;619QM2HLuRX4]~361+,[uFp6f"JF5R`y
References: <4A675F89.50506@nortel.com>
From: dick.streefland@altium.nl (Dick Streefland)
Subject: Re: question for C preprocessor wizards
Content-Type: text/plain; charset=us-ascii
NNTP-Posting-Host: 172.17.1.66
Message-ID: <4c5d.4a687cd4.a6013@altium.nl>
Date: Thu, 23 Jul 2009 15:08:04 -0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Chris Friesen" <cfriesen@nortel.com> wrote:
| I've got a bunch of code that call a bunch of different wrapper
| routines, with varying numbers of arguments.  Depending on whether a
| compile flag is set, I want to do some stuff before and after calling
| the "real" routine.  I can do this easily enough with a macro.
| 
| #if FLAG
| #define func_wrapper(args...) \
| 	do { \
| 		dostuff(); \
| 		func(args); \
| 		do_more_stuff(); \
| 	} while (0)
| #else
| #define func_wrapper(args...) func(args)
| #endif
| 
| 
| However, given that there are hundreds of functions, I'd like to
| generate these macros with another macro, sort of like:
| 
| #if FLAG
| #define WRAPPER(func) \
| 	#define func # _wrapper(args...) \
| 	do { \
| 		dostuff(); \
| 		func(args); \
| 		do_more_stuff(); \
| 	} while (0)
| #else
| #define WRAPPER(func) \
| 	#define func ## _wrapper(args...) func(args)
| #endif

You cannot generate preprocessing directives with macro expansion.
An alternative is to use a generic wrapper macro, and use that to
define wrappers for the functions. Something like:

#if FLAG
#define generic_wrapper(func, args...) \
        do { \
                dostuff(); \
                func(args); \
                do_more_stuff(); \
        } while (0)
#else
#define generic_wrapper(func, args...) func(args)
#endif

#define func1_wrapper(args...) generic_wrapper(func1, args)
#define func2_wrapper(args...) generic_wrapper(func2, args)
#define func3_wrapper(args...) generic_wrapper(func3, args)
...

-- 
Dick Streefland                      ////                      Altium BV
dick.streefland@altium.nl           (@ @)          http://www.altium.com
--------------------------------oOO--(_)--OOo---------------------------

