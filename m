Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbYH0Hrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbYH0Hrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbYH0HrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:47:25 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:40616 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753723AbYH0HrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:47:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=47zcGTXt6gaZeXAuVhIzke9PpyWcl4fvAqb14f0zIcJQQUFkiblBVpTpCNbDvTuuI1hw+ErrVvfnsrtODtD95CZaQBxGIkh/2qMLajM8IGlZV9vP4SeMJaRCfLKdaugNCu7jplY1uINlhMuHb0NeukSbnv7UnZb8E9brF0GG7IU=  ;
X-YMail-OSG: s4l2E9MVM1nkN6FuZjIk0RIvRB.ZBL3mZFrQMDkzdxtoH4IY4hG48NaucYZODhrWrvQz0NaN.gvDY864_HL8EXyOHJB7DECm4qHIcO6JeGYWiQcBkUw_vUZ3sBqj3wmsyWO8kRR.ukgYMG.Tb1SdLlIF
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Miller <davem@davemloft.net>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Date: Wed, 27 Aug 2008 17:47:14 +1000
User-Agent: KMail/1.9.5
Cc: travis@sgi.com, davej@redhat.com, torvalds@linux-foundation.org,
       Alan.Brunelle@hp.com, mingo@elte.hu, tglx@linutronix.de, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       akpm@linux-foundation.org, arjan@linux.intel.com, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, tony.luck@intel.com, steiner@sgi.com,
       cl@linux-foundation.org
References: <20080826192848.GA20653@redhat.com> <200808271654.32721.nickpiggin@yahoo.com.au> <20080827.000506.177643294.davem@davemloft.net>
In-Reply-To: <20080827.000506.177643294.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271747.14690.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 August 2008 17:05, David Miller wrote:
> From: Nick Piggin <nickpiggin@yahoo.com.au>
> Date: Wed, 27 Aug 2008 16:54:32 +1000
>
> > 5% is a pretty nasty performance hit... what sort of benchmarks are we
> > talking about here?
> >
> > I just made some pretty crazy changes to the VM to get "only" around 5
> > or so % performance improvement in some workloads.
> >
> > What places are making heavy use of cpumasks that causes such a slowdown?
> > Hopefully callers can mostly be improved so they don't need to use
> > cpumasks for common cases.
>
> It's almost certainly from the cross-call dispatch call chain.
>
> As just one example, just to do a TLB flush mm->cpu_vm_mask probably
> gets passed around as an aggregate two or three times on the way down
> to the APIC programming code on x86.  That's two or three 512 byte
> copies on the stack :)

Yeah, I see. That's stupid isn't it? (Well, I guess it was completely
sane when cpumasks were word sized ;))

Hopefully that accounts for a significant chunk...
