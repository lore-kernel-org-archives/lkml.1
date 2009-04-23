Return-Path: <linux-kernel-owner+w=401wt.eu-S1758498AbZDWNld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498AbZDWNld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZDWNlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:41:23 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:49706 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbZDWNlV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:41:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=lJ94YqcEv1VRPbMRh4Y5pod+mz41YZnv+yfk5bIfO/JWqZMhXxU1Ncx8siBVm0M1nJ
         EcIoLLoeTAa8l6LWrPKsqwlbrOiPf/Y4NH3ndCVYGHcNzUjZq9qDliGSYSrPHDUQxx5/
         emPdYFID2rWKuyxECpnXptXUpCO1jyFmLWIQ0=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 2/2] x86 amd fix cmpxchg read acquire barrier
Date: Thu, 23 Apr 2009 15:41:17 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3; KDE/4.2.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mark.langsdorf@amd.com, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@qumranet.com>
References: <20090422201852.092307236@polymtl.ca> <20090423080645.GF22606@elte.hu> <20090423131941.GA11261@Krystal>
In-Reply-To: <20090423131941.GA11261@Krystal>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904231541.18041.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 of April 2009, Mathieu Desnoyers wrote:
> * Ingo Molnar (mingo@elte.hu) wrote:
> > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > " // Opteron Rev E has a bug in which on very rare occasions a locked
> > >   // instruction doesn't act as a read-acquire barrier if followed by a
> > >   // non-locked read-modify-write instruction.  Rev F has this bug in
> > >   // pre-release versions, but not in versions released to customers,
> > >   // so we test only for Rev E, which is family 15, model 32..63
> > > inclusive.
> >
> > Dunno. The fix looks a bit intrusive (emits a NOP even on good
> > CPUs). Also, the text above says "not in versions released to
> > customers".
> >
> > So unless there's an official erratum or reports in the field (not
> > from early prototype systems shipped to developers) i'd not rush to
> > apply it, just yet.
>
> Actually, Operon Rev E has this bug in the field (family 15, model
> 32..64). Rev F only had the bug in pre-releases.
>
> But yes, it's bad that it drags so many code additions to something as
> critical as cmpxchg. I start to think it might be better to just
> disallow bringing up more than one CPU on these machines.

That probably would be even worse than what we have now. This bug doesn't 
manifest too often in a noticeable way here (I have few such machines here, 
mostly 2 x dual core; once per few months mysql dies) and loosing 3 of 4 cores 
(or 1 cpu of 2; depends on what you mean) doesn't sound like fun.

> Mathieu


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

