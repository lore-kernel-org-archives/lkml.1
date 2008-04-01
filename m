Return-Path: <linux-kernel-owner+w=401wt.eu-S1762646AbYDAPbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762646AbYDAPbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760050AbYDAP1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:27:08 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:59162 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761872AbYDAP1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jnfIjJJFD8N6NUvAiUwVXtPHqIka+ZYEzmtESBXWVFB6NKqC1TThtpOPzj5MLqYsaO740E/6ORWKmx1GnQYS7dxRK3KcGjn1rzCJ94db+EAwtFlCq2PQZaaM2hgEqkxyHDip0+MxQiiyvZtDfVllIEwrY3m2Y5zDlH83xTgTMdE=
Message-ID: <76366b180804010827r3a8094c6kae46bc3d629eccc9@mail.gmail.com>
Date: Tue, 1 Apr 2008 11:27:04 -0400
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: "Oliver Schuster" <oliver.s@inbox.com>
Subject: Re: [PATCH][WATCHDOG] v2.6.25-rc7: it8712f_wdt.c contains an error - was Re: [WATCHDOG] v2.5.25-rc patches
Cc: "Wim Van Sebroeck" <wim@iguana.be>, "Oliver Schuster" <olivers137@aol.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47F24F6D.6000603@inbox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080310201419.GA7623@infomag.infomag.iguana.be>
	 <47D6CC23.5020202@aol.com>
	 <20080311210232.GE7505@infomag.infomag.iguana.be>
	 <47F24F6D.6000603@inbox.com>
X-Google-Sender-Auth: 19afd1b2ab3a1653
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver,

Sorry, the previous e-mail slipped by me. I'll try this out later and update.

Thanks,
-Andrew

On Tue, Apr 1, 2008 at 11:06 AM, Oliver Schuster <oliver.s@inbox.com> wrote:
> Hi,
>
>  i've mailed before to lkml and Andrew Paprocki (2008-03-12) directly.
>  But the original patch wasn't changed. Here's a patch to correct the
>  error.
>
>  Description of the error:
>  By introducing the support of 16 Bit timer values for later it8712 an
>  error was made. The value is stored through superio_outw() which cause,
>  that the upper Byte is in the Register called "Watch Dog Timer Time-Out
>  Value (LSB) Register" and the lower in "Watch Dog Timer Time-Out Value
>  (MSB) Register".
>
>  A common value is 60: stored this way the watchdog timer runs out
>  in 4h 16mins. In case of a deadlocked server this is a long time to
>  wait, before the service comes back!
>
>  Regards,
>  Oliver
>
>  Wim Van Sebroeck schrieb:
>  > Hi Oliver,
>  >
>  >> this patch can cause serious problems in the case, that someone use it
>  >> with an it8712 rev. 8 and above.
>  > ...
>  >> Your patch changes it8712f_wdt.c in function t8712f_wdt_update_margin():
>  >>
>  >>> -   superio_outb((margin > 255) ? (margin / 60) : margin, WDT_TIMEOUT);
>  >>> +   if (revision >= 0x08)
>  >>> +           superio_outw(units, WDT_TIMEOUT);
>  >>> +   else
>  >>> +           superio_outb(units, WDT_TIMEOUT);
>  >> but here you can't use superio_outw, because the bytes are swapped
>  >> --historical reason.
>  >>
>  >> I suggest to substitute
>  >>      superio_outw(units, WDT_TIMEOUT);
>  >> with
>  >>      superio_outb(units >> 8, WDT_TIMEOUT + 1);
>  >>      superio_outb(units, WDT_TIMEOUT);
>  >>
>  >
>  > Can you keep "Andrew Paprocki" <andrew@ishiboo.com> in the loop?
>  > Can you also create a patch and test it together with Andrew?
>  > We need to make sure that we fix this before 2.6.25 is there.
>  >
>  > Thanks,
>  > Wim
>
>
>
