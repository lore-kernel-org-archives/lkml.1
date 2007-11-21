Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbXKUUE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbXKUUE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 15:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbXKUUEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 15:04:50 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:58148 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbXKUUEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 15:04:48 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: some thoughts about TSC based delay_tsc()
Date: Wed, 21 Nov 2007 22:06:34 +0200
User-Agent: KMail/1.9.7
References: <200711212057.10465.mitov@issp.bas.bg> <20071121192754.GA22769@elte.hu>
In-Reply-To: <20071121192754.GA22769@elte.hu>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711212206.34339.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 November 2007 09:27:54 pm you wrote:
> * Marin Mitov <mitov@issp.bas.bg> wrote:
> > Hi Ingo,
> >
> > The patch is quite good ;-) but we forget when it is needed :-( In
> > fact we need it only for PREEMPT SMP kernels - it could hurt PREEMPT
> > UP kernels (no migration possible), so no need for
> > preempt_disable()/preempt_enable().
> >
> > In short the old version of delay_tsc() is good for UP kernels and NON
> > PREEMPT SMP kernels too.
>
> please reply to the public list, so that discussions do not get lost.
>
> i dont think there's any problem: udelay() is about _wasting_ cycles -
> it's what drivers use for short delays.

Sure for the thread executing udelay(), but not for the other ready threads 
which should also wait till preempt_enable() to grab the same cpu even 
for PREEMPT (UP or SMP) kernels (or I misunderstand something?).

Marin 
>
> 	Ingo


