Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbYL3DnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbYL3DnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 22:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbYL3Dmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 22:42:54 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:23004 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752407AbYL3Dmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 22:42:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=xU0l33DMD15/hUblx+JhY5CRAQMaE2IcrFNCoVice2L0TbKaAQc/lH7BpvmrlMApvvNHUzaAjf9hV3CtPPbV517sFy7GwMNfAVbtOfboNdgtkIK+BlS36quLjzdkwO2rzcczFMONsL4CiHVYMyBXc16LDgw8qbnSeAy505TpCYQ=  ;
X-YMail-OSG: AxNYOpQVM1nryYo8xm7exEeNjZw94hk4JThiQy_vp57qtXslsZS2.kqWKsD4VNgj1cWELtGyOG.Q6NNIVd8ngg8gTAES_ad.VnXw0GwaaRSxOmTCwHlEK0b2mYa_ku6fRDZehTznO1RAoWsoEHfosmty3qRtZBYXbZDAoN4Zrlcaj.FKfZ9DmPWYzBOa_w--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC] vm_unmap_aliases: allow callers to inhibit TLB flush
Date: Tue, 30 Dec 2008 14:42:36 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <49416494.6040009@goop.org> <200707241140.12945.nickpiggin@yahoo.com.au> <49470433.4050504@goop.org>
In-Reply-To: <49470433.4050504@goop.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812301442.37654.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 December 2008 12:28:19 Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > On Friday 12 December 2008 12:59, Jeremy Fitzhardinge wrote:

> >> No.  Well, yes, it would, but Xen itself will do whatever tlb flushes
> >> are necessary to keep it safe (it must, since it doesn't trust guest
> >> kernels).  It's fairly clever about working out which cpus need flushing
> >> and if other flushes have already done the job.
> >
> > OK. Yeah, then the problem is simply that the guest may reuse that
> > virtual memory for another vmap.
>
> Hm.  What you would you think of a "deferred tlb flush" flag (or
> something) to cause the next vmap to do the tlb flushes, in the case the
> vunmap happens in a context where the flushes can't be done?

Sorry to get back to you late... I would just prefer to have a flushing mode
that clears page tables but leaves the vm entries there that will get picked
up and flushed naturally as needed.

I have patches to move the tlb flushing to an asynchronous process context...
but all tweaks to that (including flushing at vmap) are just variations on the
existing flushing scheme and don't solve your problem, so I don't think we
really need to change that for the moment (my patches are mainly for latency
improvement and to allow vunmap to be usable from interrupt context).



