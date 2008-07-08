Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbYGHP6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbYGHP6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 11:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbYGHP6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 11:58:46 -0400
Received: from gw.goop.org ([64.81.55.164]:32943 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbYGHP6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 11:58:46 -0400
Message-ID: <48738EAC.6090707@goop.org>
Date: Tue, 08 Jul 2008 08:58:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Rik van Riel <riel@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, Petr Tesarik <ptesarik@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
 with irqs disable
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com> <200807081207.34453.nickpiggin@yahoo.com.au> <487301B0.8050801@goop.org> <200807081841.50422.nickpiggin@yahoo.com.au>
In-Reply-To: <200807081841.50422.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Sure. Btw. I have no problems with your patchset, but if SMP guests
> are seriously used on x86, just remember the fairness issue. At some
> point you might find you'll need an even more advanced lock for Xen.
>   

Perhaps.  The spin lock has a bounded number of iterations before it 
goes into the vcpu-blocking path.  At that point, it's no longer subject 
to the whims of the cache coherency protocol, and is explicitly woken.  
But it may still have issues when competing with a rapid lock-unlocker.

A ticket-lock variant with some kind of directed yield might be the way 
to go if it turns out to be a problem.

    J
