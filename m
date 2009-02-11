Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbZBKPoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbZBKPoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbZBKPoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:44:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55748 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009AbZBKPoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:44:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: ACPI: S4 disappeared [mmotm 2009-02-10-16-35]
Date: Wed, 11 Feb 2009 16:43:09 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc4-tst; KDE/4.2.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>, Ingo Molnar <mingo@elte.hu>
References: <200902110036.n1B0aBZs013975@imap1.linux-foundation.org> <499291A3.9070501@gmail.com> <4992A59F.5090502@gmail.com>
In-Reply-To: <4992A59F.5090502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902111643.10191.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 February 2009, Jiri Slaby wrote:
> On 02/11/2009 09:51 AM, Jiri Slaby wrote:
> > On 02/11/2009 01:36 AM, akpm@linux-foundation.org wrote:
> >> The mm-of-the-moment snapshot 2009-02-10-16-35 has been uploaded
> > 
> > Hi,
> > 
> > I've found out, that S4 disappeared in this release, in comparison to mmotm
> > based on 2.6.29-rc2:
> > -ACPI: (supports S0 S1 S3 S4 S5)
> > +ACPI: (supports S0 S1 S3 S5)
> > 
> > Any ideas what could have caused this?
> 
> I think this one
> ARCH_HIBERNATION_POSSIBLE=n
> because
> SMP=y
> since
>  config ARCH_HIBERNATION_POSSIBLE
>         def_bool y
> -       depends on !SMP || !X86_VOYAGER
> +       depends on !SMP
> 
> The condition was wrong, ok, anyway it worked. Would
> depends on !SMP || EXPERIMENTAL
> make sense? The smp is handled in disable_nonboot_cpus manner, right?

Ah, someone removed X86_VOYAGER and left this gem.  I guess that went in
through -tip (Ingo CCed).

After removing X86_VOYAGER, ARCH_HIBERNATION_POSSIBLE should always be set
on x86.  Just make it

config ARCH_HIBERNATION_POSSIBLE
         def_bool y

Thanks,
Rafael
