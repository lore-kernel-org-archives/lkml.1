Return-Path: <linux-kernel-owner+w=401wt.eu-S1030464AbXCAWX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030464AbXCAWX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 17:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030468AbXCAWX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 17:23:58 -0500
Received: from ozlabs.org ([203.10.76.45]:34946 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030464AbXCAWX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 17:23:58 -0500
Subject: Re: [kvm-devel] [RFC][KVM] Adding a signal mask to KVM_RUN
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <45E6EC49.9050308@qumranet.com>
References: <45E6EC49.9050308@qumranet.com>
Content-Type: text/plain
Date: Fri, 02 Mar 2007 09:23:05 +1100
Message-Id: <1172787785.10271.55.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 17:07 +0200, Avi Kivity wrote:
> I'd like to add a signal mask to kvm, so that when the guest executes, 
> the signal mask is temporarily set to some user specified value.  This 
> allows signals to be used as a way to interrupt the guest, but without 
> requiring signal delivery to the userspace handler (which is what makes 
> signals expensive).

Hi Avi!

	lguest uses SIGUSR1 for similar reasons (console input, incoming
packet).  Basically it forks and the child does a select, then sends
SIGUSR1 to the parent whenever the select returns, to pop the parent out
of the kernel/guest.

	It's nasty in another respect: the race between checking signal and
entering kernel.  (Hence my child sends SIGUSR1 whenever select returns,
but it runs at v. low prio so it usually only sends one before the
parent clears the fd).

	My original code passed an fd into the kernel: whenever the fd was
readable, the lg module returned to userspace.  This avoids the race,
but might be more awkward to use.  I shied away from a complete
select/poll-style mask which would have done exactly what I wanted, but
perhaps this should be considered.

Rusty.


