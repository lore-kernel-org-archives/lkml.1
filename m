Return-Path: <linux-kernel-owner+w=401wt.eu-S965691AbXGSRaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965691AbXGSRaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765607AbXGSR3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:29:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759991AbXGSR3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:29:51 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH for review] [12/48] x86_64: use the global PIT lock
Date: Thu, 19 Jul 2007 19:29:39 +0200
User-Agent: KMail/1.9.6
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
References: <20070719348.540885000@suse.de> <20070719134841.5677614E6E@wotan.suse.de> <d120d5000707190822v44ca6fb0lefcc5302d3f7b8de@mail.gmail.com>
In-Reply-To: <d120d5000707190822v44ca6fb0lefcc5302d3f7b8de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191929.40016.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 17:22:38 Dmitry Torokhov wrote:
> Hi Andi,
> 
> On 7/19/07, Andi Kleen <ak@suse.de> wrote:
> >
> > From: Thomas Gleixner <tglx@linutronix.de>
> >
> > Replace the pcspkr private PIT lock by the global PIT lock to serialize the
> > PIT access all over the place.
> >
> 
> Like I said before I'd be more happy if spinlock was attached to a
> platform device that pcspkr binds to so the arch code would control
> wehther we use a private spinlock or a global one (I sent a patch to
> that effect earlier). 

Not sure that flexibility is needed. Why would an architecture ever want
to have more than one lock for this? And we normally don't need sysdevs
for locks, they seem to be quite unrelated.

AFAIK sysdevs are just for suspend/resume, and even for that they seem
to get obsoleted now.

-Andi
