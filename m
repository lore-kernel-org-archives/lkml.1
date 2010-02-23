Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0BWTsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 14:48:15 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:56278 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0BWTsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 14:48:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=K5MhxUGVs1T7u2K1nMc3qvumkHtn1/4+ziEQKIUdpYFn81fAuSt+9ULVRiLSV81iep
         kIJ3OzQnb31JV2Otf4ONjHyKMLXbTtd9FmS3WhASpbYU3F9G7QuB5D31onwjCq9C/ILY
         q86nVbiZBuQgaNaFyEWgtOzTeMnrHyK7H0vTw=
Date: Wed, 24 Feb 2010 01:12:53 +0530
From: Rabin Vincent <rabin@rab.in>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>
Subject: Re: [PATCH 02/10] ARM: ftrace: document mcount formats
Message-ID: <20100223194253.GB6325@debian>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
 <1266090518-31120-3-git-send-email-rabin@rab.in>
 <20100213203748.GC16528@pengutronix.de>
 <20100222180624.GA4061@debian>
 <20100222192009.GA13527@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100222192009.GA13527@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 08:20:09PM +0100, Uwe Kleine-König wrote:
> On Mon, Feb 22, 2010 at 11:36:24PM +0530, Rabin Vincent wrote:
> > On Sat, Feb 13, 2010 at 09:37:48PM +0100, Uwe Kleine-König wrote:
> > > On Sun, Feb 14, 2010 at 01:18:30AM +0530, Rabin Vincent wrote:
> > > > + * With both the mcount types, we need to restore the original lr before
> > > > + * returning.  In the __gnu_mcount_nc, version we're allowed to clobber ip.
> > > > + * No other registers should be clobbered.
> > > > + */
> > > Very nice.
> > > 
> > > Maybe make the last two sentences:
> > > 
> > > In the __gnu_mcount_nc case the ip register is clobbered which is OK as
> > > the calling convention for ARM allow clobbering this value for
> > > subroutines and it doesn't contain parameters.
> > 
> > Won't quoting calling conventions here be misleading?  The mcounts don't
> > following normal convention for the other bits (we can't clobber even
> > the registers that are normally caller-saved, we need to restore lr,
> > etc.)
> actually mcount is a function in the middle of a function call.  So it
> must be transparent for both the caller and the callee.  As the called
> function needs to know the return address, mcount must not clobber it.
> And as ip is don't care and can be clobbered mcount can use it as it
> likes.

OK.  How about this for the last paragraph:

 mcount can be thought of as a function called in the middle of a
 subroutine call.  As such, it needs to be transparent for both the
 caller and the callee: the original lr needs to be restored when
 leaving mcount, and no registers should be clobbered.  (In the
 __gnu_mcount_nc implementation, we clobber the ip register.  This
 is OK because the ARM calling convention allows it to be clobbered
 in subroutines and doesn't use it to hold parameters.)

Rabin
