Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbYHABc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbYHABc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 21:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYHABcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 21:32:48 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:28287 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752149AbYHABcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 21:32:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XOQGK7Bl1h7eYHGbdTPSMznPu/G1UmzL8+f57J480Jw+ckwLWTRdSAINjfZ5IlUpK0BB05e0L+4eDiGvAFFHAc3Mtk8lTTaez/HrNnHptu/xlNYy4m7v9z7DsinYQjAxPI2J/CIGRtkEfpduq+Z1/KsKsXzQOjLh9SHPy+vnp+I=  ;
X-YMail-OSG: EWzAIy4VM1kHFHd_4Sh8q6vW4Fi1ynmuvQd.2kjxpKY3hEvgQ4C46VmP6wwZ9UUr.BIpRuqh3ngVC5rY2AmYn_mh5e_Vlrs6oy0pM59rn7HBS7vZakG2r1.eMtRHHsXGYYc-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: x86: Is there still value in having a special tlb flush IPI vector?
Date: Fri, 1 Aug 2008 11:32:32 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <peterz@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <488E534F.2030204@goop.org> <1217328351.7563.12.camel@twins> <20080731164826.GH26393@elte.hu>
In-Reply-To: <20080731164826.GH26393@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808011132.32856.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 August 2008 02:48, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:

> > The overhead of that is a smp_mb() and a list_empty() check in
> > generic_smp_call_function_single_interrupt() if there is indeed no
> > work to do.
>
> that would be a miniscule cost - cacheline is read-shared amongst cpus
> so there's no real bouncing there. So i'm all for it ...

smp_mb would cost some cycles. So would the branch mispredict because
list_empty would otherwise normally be taken I think. q likely is not
in cache either.

I'm not in favour.
