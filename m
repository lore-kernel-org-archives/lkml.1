Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbXLZUiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbXLZUiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 15:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbXLZUiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 15:38:46 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:15252 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbXLZUip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 15:38:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=e7NGZlXAB90EbnG2p0G03iB5EPCR99bl3SsT2sxZXrNKaFEFel0u5D6FRu9DlAZwjCYsWvBM+sXmoQ0hPQX+I7UGRzpiOa1497MNYqZ2gezMzAAex8LiKLELDPgm7LEqT7yS38MfKc31Hlq9bLk966lT5c5e2AovA41OTf9g/bE=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Testing RAM from userspace / question about memmap= arguments
Date: Wed, 26 Dec 2007 22:37:52 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Pavel Machek <pavel@ucw.cz>, Matthew Bloch <matthew@bytemark.co.uk>,
       linux-kernel@vger.kernel.org
References: <fk8umh$n7o$1@ger.gmane.org> <20071225230957.GB29030@elf.ucw.cz> <20071226021756.7ae9db08@laptopd505.fenrus.org>
In-Reply-To: <20071226021756.7ae9db08@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712262237.52818.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В сообщении от Wednesday 26 December 2007 12:17:56 Arjan van de Ven написал(а):
> On Wed, 26 Dec 2007 00:09:57 +0100
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > On Sat 2007-12-22 12:09:59, Arjan van de Ven wrote:
> > > On Tue, 18 Dec 2007 17:06:24 +0000
> 
> > > memtest86+ does various magic to basically bypass the caches (by
> > > disabling them ;-)... Doing that in a live kernel situation, and
> > > from userspace to boot...... that's... and issue.
> > 
> > Are you sure? I always assumed that memtest just used patterns bigger
> > than L1/L2 caches...
> 
> that's... not nearly usable or enough. Caches are relatively smart
> about things like use-once.... and they're huge. 12Mb today. You'd need
> patterns bigger than 100Mb to get even close to being reasonably
> confident that there's nothing left.
> 
> > ... and IIRC my celeron testing confirmed it, if
> > I disabled L2 cache in BIOS, memtest behave differently.
> > 
> > Anyway, if you can do iopl(), we may as well let you disable caches,
> > but you are right, that will need a kernel patch.
> 
> and a new syscall of some sorts I suspect; "flush all caches" is a ring
> 0 operation (and you probably need to do it in an ipi anyway on all
> cpus)
> 

I think that PAT support will help a lot.
How about opening/mmaping /dev/mem, and setting uncacheable attribute there.
Actually it is even possible today with MTRRs.

Regards,
	Maxim Levitsky
