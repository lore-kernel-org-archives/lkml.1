Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbYJ3WGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbYJ3WGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYJ3WGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:06:12 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51772 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752972AbYJ3WGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:06:10 -0400
Subject: Re: [PATCH] fix smp generic helper voyager breakage
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <Jens.Axboe@oracle.com>
In-Reply-To: <20081030215421.GG30303@elte.hu>
References: <1225400980.19324.24.camel@localhost.localdomain>
	 <20081030215421.GG30303@elte.hu>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 17:06:08 -0500
Message-Id: <1225404368.19324.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 22:54 +0100, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > +++ b/arch/x86/Kconfig
> > @@ -167,9 +167,11 @@ config GENERIC_PENDING_IRQ
> >  config X86_SMP
> >  	bool
> >  	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
> > -	select USE_GENERIC_SMP_HELPERS
> >  	default y
> >  
> > +config USE_GENERIC_SMP_HELPERS
> > +	def_bool y
> > +
> 
> uhm, that's a bogus change - USE_GENERIC_SMP_HELPERS must not be set 
> on UP. This will break all UP compilations, on all x86 UP boxes:

Heh, that would be one thing I don't build in my test rig.

> kernel/softirq.c: In function '__try_remote_softirq':
> kernel/softirq.c:522: error: implicit declaration of function '__smp_call_function_single'
> 
> so i've removed your patch for now.

OK, I'll update it ... I assume it should depend on CONFIG_SMP then?

James


