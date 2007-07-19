Return-Path: <linux-kernel-owner+w=401wt.eu-S1765506AbXGSVGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765506AbXGSVGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761917AbXGSVG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:06:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:33114 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762189AbXGSVGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:06:25 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patches] new text patching for review
Date: Thu, 19 Jul 2007 23:06:20 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, Zachary Amsden <zach@vmware.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>
References: <200707191105.44056.ak@suse.de> <200707192246.58047.ak@suse.de> <469FCEE7.8060900@goop.org>
In-Reply-To: <469FCEE7.8060900@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707192306.20625.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 22:51:51 Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > Normally there are not that many NMIs or MCEs at boot, but it would
> > be still good to avoid the very rare crash by auditing the code first
> > [better than try to debug it on some production system later]
> >   
> 
> Auditing it for what?  If we want to make patching safe against NMI/MCE,
> I guess we need to make sure those handlers don't use any pvops, but
> that seems unreasonable if they want to poke at MSRs and so on.

Either not use any pvops or make sure all the pvops patching is atomic
on the local CPU.

Ok you can avoid MCEs by not enabling them until after you patch (which I think
is the case currently), but it's more difficult with NMIs.

The plain NMI handler is probably auditable.
Or set a flag that makes the NMI handler just return during patching?

> 
> > In theory yes, in practice there can be errata of course. There tend 
> > to be a couple with self modifying code, especially cross modifying
> > (from another CPU) -- but you don't do that.
> >   
> 
> No, but the pv-ops patching code should have no requirement for
> atomicity at all; we shouldn't be trying to patch a live instruction stream.

Yes, but NMI could happen inbetween

-Andi
