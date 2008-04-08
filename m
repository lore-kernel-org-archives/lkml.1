Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbYDHLuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbYDHLuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbYDHLuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:50:05 -0400
Received: from dtp.xs4all.nl ([80.126.206.180]:24682 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751683AbYDHLuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:50:03 -0400
Date: Tue, 8 Apr 2008 13:43:21 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, R.E.Wolff@BitWizard.nl
Subject: Re: [PATCH] drivers/char/specialix.c: stop inlining largish static functions
Message-ID: <20080408114321.GB1236@bitwizard.nl>
References: <200804081244.53894.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804081244.53894.vda.linux@googlemail.com>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 12:44:53PM +0200, Denys Vlasenko wrote:
> Hi Alan,
> 
> drivers/char/specialix.c has unusually large number
> of static inline functions - 22.
> 
> I looked through them. The file is positively inline-happy.
> Inlines with udelay() calls. Inlines with complex loops.
> Nested inlines. Rarely called inlines (e.g. with request_region
> inside).
> 
> This patch removes "inline" from 15 static functions
> (regardless of number of callsites - gcc nowadays auto-inlines
> statics with one callsite).
> 
> Size difference for 32bit x86:
>    text    data     bss     dec     hex filename
>   21669     204    8780   30653    77bd linux-2.6-ALLYES/drivers/char/specialix.o
>   18470     204    8780   27454    6b3e linux-2.6.inline-ALLYES/drivers/char/specialix.o
> 
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Ack!

Signed-off-by: Rogier Wolff <R.E.Wolff@BitWizard.nl> 

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
