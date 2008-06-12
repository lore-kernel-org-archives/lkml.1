Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbYFLWKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbYFLWKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYFLWKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:10:04 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:19158 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbYFLWKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:10:02 -0400
Subject: Re: [PATCH 5/5] futex: fix miss ordered wakeups
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ulrich Drepper <drepper@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0806121802050.3193@apollo.tec.linutronix.de>
References: <20080611204916.271608740@mvista.com>
	 <20080611204917.523866467@mvista.com>
	 <alpine.LFD.1.10.0806121022250.3193@apollo.tec.linutronix.de>
	 <1213277402.16459.25.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0806121533270.3193@apollo.tec.linutronix.de>
	 <1213278286.16459.29.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0806121636380.3193@apollo.tec.linutronix.de>
	 <1213286193.16459.53.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0806121802050.3193@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 15:09:58 -0700
Message-Id: <1213308598.16459.82.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-12 at 21:55 +0200, Thomas Gleixner wrote:
> Also your interpretation of the POSIX requirement is very
> questionable:
> 
>  "If there are threads blocked on the mutex object referenced by mutex
>  when pthread_mutex_unlock() is called, resulting in the mutex
>  becoming available, the scheduling policy shall determine which
>  thread shall acquire the mutex."

The key is "scheduling policy" .. When the mutex is un-blocked the next
task to run is the same as if the scheduler was selecting tasks from the
list of blocked tasks .. For Linux, that means the highest priority
tasks should be selected.. So it's no more acceptable for the scheduler
to priority invert some tasks than it is for the futex to do it.

Daniel

