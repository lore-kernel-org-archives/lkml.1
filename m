Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYJKD4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYJKD4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 23:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbYJKD4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 23:56:22 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:36035 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751849AbYJKD4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 23:56:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sabzvR27a33AkNK019UgWLZt2ueQt4L3euyv7wfE0/fYxFi4ZfsN2+I7MwiigQqylQPbg76rUfky4d0Sp9DPQpz0UF65e3XRa7dZBb5I4PqEgpgqKRzVUpuEp6OWe7DsnKTT+gBdLBgcxOam1gTmTVDKhchjEIJWJwDbUQSeFyw=  ;
X-YMail-OSG: nkqdGYYVM1kKbgXnJQnJNW5OiO0pS.dP1ibpY3jYXU6DExLs5Ix3K0r6kN7KoPN8147Sh_gtmGZe3a0DeIjQ9Gksnfe_BfuoqxX9nQ44TjVOCNqwJdGB2sxlxO2T0JHIzUasBAA_dC2FFFz.O1DRm7vRZbZOUpnlkxOxCiFsUdjRHvzbhFFC8A1d5Iul
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "H. Peter Anvin" <hpa@kernel.org>
Subject: Re: Update cacheline size on X86_GENERIC
Date: Sat, 11 Oct 2008 14:56:11 +1100
User-Agent: KMail/1.9.5
Cc: Dave Jones <davej@redhat.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <20081009171453.GA15321@redhat.com> <200810101428.23662.nickpiggin@yahoo.com.au> <48EF9E6F.5050006@kernel.org>
In-Reply-To: <48EF9E6F.5050006@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810111456.11672.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 October 2008 05:26, H. Peter Anvin wrote:
> Nick Piggin wrote:
> > I think P4 technically did have 64 byte cachelines, but had some adjacent
> > line prefetching. And AFAIK core2 CPUs can do similar prefetching (but
> > maybe it's smarter and doesn't cause so much bouncing?).
> >
> > Anyway, GENERIC kernel should run well on all architectures, and while
> > going too big causes slightly increased structures sometimes, going too
> > small could result in horrible bouncing.
>
> Well, GENERIC really is targetted toward the commercial mainstream at
> the time, with the additional caveat that it shouldn't totally suck on
> anything that isn't so obscure it's irrelevant.  It is thus a moving
> target.  1% on TPC doesn't count as "totally suck", especially since by
> now anyone who is running workloads like TPC either will have phased out
> their P4s or they don't care about performance at all.

tpc shouldn't have too false sharing these days, AFAICT (slab is rather
important there, but it finds cacheline sizes at runtime). Actually I
thought Andi was referring to the slowdown on 64-byte cacheline systems.
But other workloads could be hurt much worse than tpc-c from false
sharing I think.


> > Lastly, I think x86 will go to 128 byte lines in the next year or two, so
> > maybe at this point we can just keep 128 byte alignment?
>
> "x86" doesn't have a cache line size; a specific implementation will.
> Which particular implementation do you believe is going to 128-byte L1
> cachelines?

Right. I thought a future implementation would. But I'm probably wrong
about that, and anyway OK it wasn't such a good argument for kernel.org
kernels I suppose.
