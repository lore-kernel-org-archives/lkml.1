Return-Path: <linux-kernel-owner+w=401wt.eu-S1762661AbYCFIif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762661AbYCFIif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 03:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYCFIiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 03:38:24 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:40105 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbYCFIiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 03:38:23 -0500
From: Stephan Diestelhorst <langer_mann@web.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] Speedfreq-SMI call clobbers ECX
Date: Thu, 6 Mar 2008 09:38:19 +0100
User-Agent: KMail/1.9.6
Cc: davej@codemonkey.org.uk, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org
References: <200803051559.09962.langer_mann@web.de> <20080305153520.GB19300@elte.hu>
In-Reply-To: <20080305153520.GB19300@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803060938.20944.langer_mann@web.de>
X-Provags-ID: V01U2FsdGVkX18NmgsmDi6lZUS2QqvauxJzK/3JJdkaHWBP/ctK
	tJPVYMfbv40p6ZwgVaorIJZNCRhAuGkIMlR5SlgU44nJg+15DG
	EO9VhI0mg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On, March 5th 2008 16:35:20 Ingo Molnar wrote:
> * Stephan Diestelhorst <langer_mann@web.de> wrote:
> > @@ -184,7 +184,7 @@ static void speedstep_set_state (unsigne
> >  		__asm__ __volatile__(
> >  			"movl $0, %%edi\n"
> >  			"out %%al, (%%dx)\n"
> > -			: "=b" (new_state), "=D" (result)
> > +			: "=b" (new_state), "=D" (result), "=c" (ecx_clobber)
> >
> >  			: "a" (command), "b" (function), "c" (state), "d" (smi_port),
> >  			: "S" (0)
> >
> >  			);
>
> stupid suggestion: why not do a pusha/popa around those
> instructions, to make sure everything is restored? This isnt a
> fastpath and being conservative about SMI side-effects cannot hurt

That sounds like a sane thing to do to me. Should I provide a 'patch'? 
Or leave that (and the decision about it) to the maintainer?

Regards,
  Stephan
