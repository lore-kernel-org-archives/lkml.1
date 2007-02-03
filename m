Return-Path: <linux-kernel-owner+w=401wt.eu-S1946211AbXBCCBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946211AbXBCCBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946213AbXBCCBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:01:24 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51188 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946211AbXBCCBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:01:24 -0500
Date: Fri, 2 Feb 2007 18:01:03 -0800
From: Andrew Morton <akpm@osdl.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: <linux-kernel@vger.kernel.org>, "Lu, Yinghai" <yinghai.lu@amd.com>,
       "Luigi Genoni" <luigi.genoni@pirelli.com>, Ingo Molnar <mingo@elte.hu>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 2/2] x86_64 irq:  Handle irqs pending in IRR during irq
 migration.
Message-Id: <20070202180103.cf1e4217.akpm@linux-foundation.org>
In-Reply-To: <m1fy9o3tq4.fsf@ebiederm.dsl.xmission.com>
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070202170500.57b6c3a3.akpm@linux-foundation.org>
	<m1fy9o3tq4.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Feb 2007 18:39:15 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Andrew Morton <akpm@osdl.org> writes:
> 
> > So is this a for-2.6.20 thing?  The bug was present in 2.6.19, so
> > I assume it doesn't affect many people?
> 
> If it's not to late, and this patch isn't too scary.
> 
> It's a really rare set of circumstances that trigger it, but the
> possibility of being hit is pretty widespread, anything with
> more than one cpu, and more then one irq could see this.
> 
> The easiest way to trigger this is to have two level triggered irqs on
> two different cpus using the same vector.  In that case if one acks
> it's irq while the other irq is migrating to a different cpu 2.6.19
> get completely confused and stop handling interrupts properly.
> 
> With my previous bug fix (not to drop the ack when we are confused)
> the machine will stay up, and that is obviously correct and can't
> affect anything else so is probably a candidate for the stable tree.
> 
> With this fix everything just works.
> 
> I don't know how often a legitimate case of the exact same irq
> going off twice in a row is, but that is a possibility as well
> especially with edge triggered interrupts.
> 
> Setting up the test scenario was a pain, but by extremely limiting
> my choice of vectors I was able to confirm I survived several hundred
> of these events with in a couple of minutes no problem.
> 

OK, thanks.  Let's await Andi's feedback.
