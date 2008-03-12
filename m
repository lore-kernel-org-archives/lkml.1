Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbYCLOlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbYCLOlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 10:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYCLOlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 10:41:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:39619 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbYCLOlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 10:41:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XbKVB8xdMWFpj00EOWzXbXrIQ/cAs5SZ/7Dyal0OCer3MVUchtWV/4ysQR5fGXnVYfXaI3oQWxUj9Bi/FSC9R6dNt1Tns45qZBCm17V/2vRp3MynclOvOX6UYCIKDALy0a9NxmdlMLVEJWO7J6UZ7IP81NPoyTdgNiZAm31oKoA=
Message-ID: <170fa0d20803120741n1f9f89ban27b18b4b671d48dd@mail.gmail.com>
Date: Wed, 12 Mar 2008 10:41:30 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Daniel Phillips" <phillips@phunq.net>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Cc: "Willy Tarreau" <w@1wt.eu>, "Chris Friesen" <cfriesen@nortel.com>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Grzegorz Kulewski" <kangur@polcom.net>, linux-kernel@vger.kernel.org,
       nbd-general@lists.sourceforge.net
In-Reply-To: <200803120117.57644.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803092346.17556.phillips@phunq.net>
	 <200803111256.51267.phillips@phunq.net> <20080311205340.GJ8953@1wt.eu>
	 <200803120117.57644.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/08, Daniel Phillips <phillips@phunq.net> wrote:
> On Tuesday 11 March 2008 13:53, Willy Tarreau wrote:
>  > BTW, I would say that IMHO nothing here makes RAID impossible to use :-)
>  > Just wire 2 of these beasts to a central server with 10 Gbps NICs and
>  > you have a nice server :-)
>
>
> Right.  See ddraid.  It is in the pipeline, but everything takes time.
>  We also need to reroll NBD complete with deadlock fixes before I feel
>  good about that.

You've eluded to NBD needing deadlock fixes quite a few times in the
past.  I've even had some discussions with you on where you see NBD
lacking (userspace nbd-server doesn't lock memory or set PF_MEMALLOC,
etc).  But I've lost track of what changes you have in mind for NBD.
Are you talking about a complete re-write or do you have specific
patches that will salvage the existing NBD client and/or server?  Has
this work already been done and you just need to dust it off?

As an aside, using a kernel with the new per bdi dirty page accounting
I've not been able to hit any deadlock scenarios with NBD.  Am I not
trying hard enough?  Or are they now mythical?  If real, do you have a
reproducible scenario that will cause NBD to deadlock?

I'm not interested in swap over NBD (e.g. network memory reserves?)
because in practice I've found that the VM doesn't allow non-swap NBD
use-cases to actually need that "netvm" sophistication... any other
workload that deadlocks NBD would interesting.

thanks,
Mike
