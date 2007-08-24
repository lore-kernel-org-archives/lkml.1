Return-Path: <linux-kernel-owner+w=401wt.eu-S932536AbXHXGLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbXHXGLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 02:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbXHXGLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 02:11:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:47672 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbXHXGLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 02:11:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=DlwZsgCAGPtNje2PdkunlDhv/sL/Ejt5yuThj1SYnMzn9i0PYmBGGR3+SSU1nWaH7UZw2HcP2ox6x+rJxUEVQv9IwcRbcccRAiRhI8/M5MTOPPcqY+zKo3QBXcPmVIc7uXGI5q0RjmBFMdM6oWxQAKuuSG+chyZRr/kG65V/RGE=
Date: Fri, 24 Aug 2007 08:06:52 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] enforce noreplace-smp in alternative_instructions()
Message-ID: <20070824060652.GF31846@slug>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <20070822202551.GB31846@slug> <46CE1541.6040809@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CE1541.6040809@goop.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 04:16:17PM -0700, Jeremy Fitzhardinge wrote:
> Frederik Deweerdt wrote:
> > On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
> >   
> >> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> >>
> >>     
> > Hi Jeremy,
> >
> > arch/i386/kernel/alternative.c:alternative_instructions() doesn't
> > check for noreplace-smp before setting capability bits and freeing the
> > __smp_locks section.
> >
> > Every call to alternatives_smp_unlock() checks for noreplace-smp
> > beforehand, so remove the check from there.
> >
> > Boot tested on i386 with UP+noreplace-smp (lguest) and SMP (real hardware)
> >   
> 
> Does this fix a real problem?  Or is there just some redundancy? 
It does, see the mail to Andrew.
> Wouldn't it be better to put the noreplace_smp test in one place?
I agree, but I don't think it is doable (alt_smp_once comes to mind). I'll
double check however.

Thanks,
Frederik
