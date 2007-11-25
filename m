Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbXKYRNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbXKYRNl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 12:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbXKYRNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 12:13:32 -0500
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:45617 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753427AbXKYRNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:13:31 -0500
X-YMail-OSG: PptiDlAVM1lhiBQ1kmvCNCcqTa_JSEgY1vbfBYtaVF1Zl23MNgp4Lourl.tUVdYdqwh4A2eHEg--
X-RocketYMMF: rancidfat
Date: Sun, 25 Nov 2007 09:13:31 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] -mm (2.6.24-rc3-mm1) Smack using capabilities 32 and 33
To: Andrew Morgan <morgan@kernel.org>, casey@schaufler-ca.com
Cc: akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <4749A3EF.1010606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <201388.56853.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andrew Morgan <morgan@kernel.org> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> 
> 
> Casey Schaufler wrote:
> > diff -uprN -X linux-2.6.24-rc3-mm1-base/Documentation/dontdiff
> linux-2.6.24-rc3-mm1-base/include/linux/capability.h
> linux-2.6.24-rc3-mm1-smack/include/linux/capability.h
> > --- linux-2.6.24-rc3-mm1-base/include/linux/capability.h	2007-11-22
> 01:51:36.000000000 -0800
> > +++ linux-2.6.24-rc3-mm1-smack/include/linux/capability.h	2007-11-24
> 11:26:51.000000000 -0800
> > @@ -314,6 +314,23 @@ typedef struct kernel_cap_struct {
> >  
> >  #define CAP_SETFCAP	     31
> >  
> > +/* Override MAC access.
> > +   The base kernel enforces no MAC policy.
> > +   An LSM may enforce a MAC policy, and if it does and it chooses
> > +   to implement capability based overrides of that policy, this is
> > +   the capability it should use to do so. */
> > +
> > +#define CAP_MAC_OVERRIDE     32
> > +
> > +/* Allow MAC configuration or state changes.
> > +   The base kernel requires no MAC configuration.
> > +   An LSM may enforce a MAC policy, and if it does and it chooses
> > +   to implement capability based checks on modifications to that
> > +   policy or the data required to maintain it, this is the
> > +   capability it should use to do so. */
> > +
> > +#define CAP_MAC_ADMIN        33
> > +
> >  /*
> >   * Bit location of each capability (used by user-space library and kernel)
> >   */
> > @@ -334,7 +351,8 @@ typedef struct kernel_cap_struct {
> >  			    | CAP_TO_MASK(CAP_DAC_OVERRIDE)	\
> >  			    | CAP_TO_MASK(CAP_DAC_READ_SEARCH)	\
> >  			    | CAP_TO_MASK(CAP_FOWNER)		\
> > -			    | CAP_TO_MASK(CAP_FSETID))
> > +			    | CAP_TO_MASK(CAP_FSETID) \
> 
> The following looks a bit fishy:
> > +			    | CAP_TO_MASK(CAP_MAC_OVERRIDE))
> 
>   (1<<32) & 0xffffffff == 0
> 
> I think you need to define CAP_FS_MASK_B1.

I think you're right, and I'll need to use it, too.


Casey Schaufler
casey@schaufler-ca.com
