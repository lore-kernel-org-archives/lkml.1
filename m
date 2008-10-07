Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYJGPA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYJGPA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYJGPAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:00:15 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:28953 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752606AbYJGPAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:00:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JJ8y8A6Lherq9rGg+4UvMPYoGCP6z/DyXMCHs/w4c8s2U9KWytuHnMPpPgIRtxUYOIJMEOwK8QtKj8RHdYXDGrdD3R+ms4Utar9z+o9jIKMRnESso7VQANB3rcu4I6ogfRvlLwPwsZ1Sj3HYABRG6sQtj+NCrgvlmMkKacKybZ0=  ;
X-YMail-OSG: W3NLD2MVM1mMfCX0mZMzemwO8LkNO1NeN4x3YJ75LcJ7VkS3vOMK0y2YL2ojKuZAk4G1zAxW4DurZvEEhwPCFjrfM0N62KbA14ua0oDnCTW_7R__8_cXSvc.IUtc5mtO1bzi2tulHohru3xNf87v_gJ_Dn8r6w--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: IRQ balancing on a router
Date: Wed, 8 Oct 2008 02:00:04 +1100
User-Agent: KMail/1.9.5
Cc: Arjan van de Ven <arjan@linux.intel.com>, Jan Kasprzak <kas@fi.muni.cz>,
       linux-kernel@vger.kernel.org
References: <20081003132117.GM16624@fi.muni.cz> <20081003063857.76b7b61a@linux.intel.com> <1223375380.26330.24.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1223375380.26330.24.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810080200.05107.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 October 2008 21:29, Peter Zijlstra wrote:
> On Fri, 2008-10-03 at 06:38 -0700, Arjan van de Ven wrote:
> > The good news is that irqthreads at least have the potential to solve
> > this "lack of information"; if not, we could consider doing a form of
> > microaccounting for irq handlers....
>
> I have some patches floating about that account for nmi/irq/softirq time
> in a fine grained scale. The trouble is that i've so far not found a way
> to handle the case of a jiffie based sched_clock().

Would be nice to have.


> The trouble with that is that time always increases in IRQ context, so
> nmi=0, softirq=0, regular=0 but irq=100%, which is obviuosly
> sub-optimal :-)

Can't you exempt the timer interrupt from counting itself as irq
in the case of timer interrupt based sched_clock()?
