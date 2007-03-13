Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbXCMXuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbXCMXuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 19:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbXCMXuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 19:50:13 -0400
Received: from ozlabs.org ([203.10.76.45]:51325 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbXCMXuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 19:50:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17911.14509.184728.839589@cargo.ozlabs.ibm.com>
Date: Wed, 14 Mar 2007 10:50:05 +1100
From: Paul Mackerras <paulus@samba.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: _proxy_pda still makes linking modules fail
In-Reply-To: <45F6C3E9.5020207@goop.org>
References: <1173315479.12472.9.camel@qrnik>
	<p73lki39s3a.fsf@bingen.suse.de>
	<45F49E0A.3090607@goop.org>
	<20070312094805.GA11644@one.firstfloor.org>
	<1173736726.10618.1.camel@localhost.localdomain>
	<1173767032.10618.43.camel@localhost.localdomain>
	<17910.26926.138067.731855@cargo.ozlabs.ibm.com>
	<45F6C3E9.5020207@goop.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge writes:

> Or do you mean that if you have:
> 
> 	preempt_disable();
> 	use_my_percpu++;
> 	preempt_enable();
> 	// switch cpus
> 	preempt_disable();
> 	use_my_percpu++;
> 	preempt_enable();
> 
> then it will still use the old pointer to use_my_percpu?

Yes.  It can, and sometimes does.  There's no way (that I know of) to
tell gcc "all my __thread variables might have moved to a different
address".

> In principle gcc could CSE the value of smp_processor_id() across a cpu
> change in the same way.

There it's easier to make gcc do what we want, because we can use a
barrier or a volatile.  The difference is that smp_processor_id() is
ultimately the value of something, not the address of something.  We
can tell gcc "values might have changed" but have no way to say
"addresses might have changed".

Paul.
