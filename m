Return-Path: <linux-kernel-owner+w=401wt.eu-S1760575AbZCYAxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575AbZCYAxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757365AbZCYAdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:33:18 -0400
Received: from ozlabs.org ([203.10.76.45]:36875 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661AbZCYAdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:33:16 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC] Correct behaviour of irq affinity?
Date: Wed, 25 Mar 2009 11:03:08 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200903241619.03517.rusty@rustcorp.com.au> <m1k56frt6e.fsf@fess.ebiederm.org>
In-Reply-To: <m1k56frt6e.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903251103.10249.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 March 2009 23:09:37 Eric W. Biederman wrote:
> desc->affinity should be what the user requested, if it is at all
> possible to honor the user space request.  YH the fact that we do not
> currently exercise the full freedom that user space gives us is
> irrelevant.

Yep, OK.

> YH has a point that several of the implementations of
> cpu_mask_to_apic_id do not take cpu_online_map into account and should
> probably be fixed.  flat_cpu_mask_to_apicid was the one I could find.

Also the numaq apic.h.  I'll do an audit and send a patch.

> Also now that I look at it there is one other bug in this routine
> that you have missed.  set_extra_move_desc should be called before
> we set desc->affinity, as it compares that with the new value to
> see if we are going to be running on a new cpu, and if so we may
> need to reallocate irq_desc onto a new numa node.  set_extra_move_desc
> looks a little fishy but it doesn't stand a chance if it is called
> with the wrong data.

Yes, agree with Yinghai's fix.  I'll re-spin my patch on top of his.

Thanks for looking at this!
Rusty.
