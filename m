Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbXJCNCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbXJCNCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 09:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbXJCNB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 09:01:57 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:33177 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752686AbXJCNB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 09:01:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5maQZNaXLf+a7wUDFXPo7z5hbBAhj0hqz6aOftmicgsvKGaXQCoSw2bm2q0WRJdXlhj4T1DDhdptzzciW3MOYOYMS+f7GRgUlF+jcbiydDJH9v2EghoECU2gr7dxkzewMcDkmEp+miQ6pd0GxTHdczjBU/s4Jyu+/mCdOi3Zx1Y=  ;
X-YMail-OSG: 89evzJwVM1mISm_k2Y4StyOmfe7mrDJRuE_9lItkD8m1KlaniB921CJsKQPBRECjhw6Ue8JfBg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Date: Wed, 3 Oct 2007 06:30:19 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com> <200710030553.27822.nickpiggin@yahoo.com.au> <20071003054149.a18b0547.pj@sgi.com>
In-Reply-To: <20071003054149.a18b0547.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710030630.19850.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007 22:41, Paul Jackson wrote:
> > pdflush
> > is not pinned at all and can be dynamically created and destroyed. Ditto
> > for kjournald, as well as many others.
>
> Whatever is not pinned is moved out of the top cpuset, on the kind of
> systems I'm most familiar with.  They are put in a smaller cpuset, with
> load balancing, that is sized for the workload they might present, but
> kept separate from the main jobs.

So if a new pdflush is spawned, it get's moved to some cpuset? That
probably isn't something these realtime systems want to do (ie. the
non-realtime portion probably doesn't want to have any sort of scheduler
or even worry about cpusets at all).


> > Basically: it doesn't feel like a satisfactory solution to brush
> > these under the carpet.
>
> We don't do a whole lot of brushing under the carpet on these kind of
> systems.  If I gave you the impression we do, then I misled you - sorry.

No, not on your systems. I'm worried about the smaller ones that don't
get so much attention (eg. hard partitioning for realtime).
