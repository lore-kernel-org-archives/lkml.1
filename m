Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbXH2Of6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbXH2Of6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 10:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbXH2Ofv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 10:35:51 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:28454 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbXH2Ofu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 10:35:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=LdW4ubamhNDUQLPa1UPRU9nI6EttPCFmiQUXCv9QJ4kaNpxxneRGwu9iWCrKCg7dNnae6jq785DfJrmKP+4naynV0WwhS8g1xwjz79GNVKje7F94XbhxwbrCPcRH05HMVQqp+8E+5JEoA4laOww3S7nIUaHdGCaFXHrKS01Apdw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: ok to kill "ether=" kernel parm?
Date: Wed, 29 Aug 2007 15:35:41 +0100
User-Agent: KMail/1.9.1
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0708280307350.3354@localhost.localdomain> <46D45A02.6010306@zytor.com> <Pine.LNX.4.64.0708281347390.20783@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0708281347390.20783@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708291535.41594.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 August 2007 18:58, Robert P. J. Day wrote:
> On Tue, 28 Aug 2007, H. Peter Anvin wrote:
> > Robert P. J. Day wrote:
> > > On Tue, 28 Aug 2007, H. Peter Anvin wrote:
> > >> Robert P. J. Day wrote:
> > >>>   given that "ether=" has been officially obsolete since 2.6.18
> > >>> (replaced by "netdev="), is there any reason to keep it around?
> > >>> or can it be blasted?
> > >>
> > >> That sounds like way too short of a timeline for breaking people's
> > >> working boot setup.  For a lot of people, 2.6.18->current is going
> > >> to be a single step.
> > >
> > > actually, now that i look more closely at the code browser at
> > > lxr.linux.no, "ether=" has been listed as "obsolete" since *at least*
> > > 2.6.10.  not to sound unsympathetic but anyone who tries to jump from
> > > 2.6.10 to 2.6.24 in one step deserves what they get.  :-)
> > >
> > > ok, that was cruel, but you see my point, right?
> >
> > Yes, and I think it's quite pointless.
> >
> > The thing is, people's boot setups have probably been that way since
> > *long* before 2.6.9.  They continue to work, as they should, so they
> > aren't changed.  This is why we very rarely break boot interfaces
> > (and this is a user-visible interface you're talking about); we're
> > still supporting interfaces that have been obsolete *SINCE BEFORE
> > 1.0 WAS RELEASED.*
> >
> > What's the upside of changing?  What's the downside?  The upside is
> > so infinitesimal that that leaving "ether=" in indefinitely seems
> > like a good move to me.
>
> i've never found these "well, it's not hurting anything" arguments
> terribly compelling.  if that's the case, why remove *anything* from
> the kernel?  why obsolete *anything*?  but that's not my actual point.
>
> why continue to support two different ways to do the same thing?  in
> situations like that, i can imagine the following (admittedly
> hypothetical) conversation between old-timer and young geek:
>
> OT:  "so, what the problem?"
> YG:  "i can't get my network module to work properly.  i use modprobe
> with netdev= and ..."
> OT:  "huh?  netdev?  why don't you use ether=?"
> YG:  "what's ether=?"
> OT:  "what's netdev=?"
>
> followed by a confused conversation as to whether they really
> represent the same thing, or maybe not, or maybe mostly.
>
> if you want to keep the old way of doing it, that's cool.  but it
> would be nice if, in cases like that, a clear choice was made.  if you
> want to keep the old way, then *keep* it.  make it clear that it's
> official, and supported.
>
> or if you're going to delete it, then *delete* it.  but let's not keep
> doing this half-way, half-assed measure of tagging something as
> obsolete, then just letting it hang out in the kernel forever.  either
> keep it, or delete it, and stop being so wishy-washy and doing things
> halfway.
>
> and, finally, while "there's more than one way to do it" may be a
> terrific perl philosophy, i don't think much of it as a kernel coding
> standard.

Add a printk("Deprecated, use netdev=xxx\n"); to the handler.
After 1-2 years you can remove ether=xxx.
--
vda
