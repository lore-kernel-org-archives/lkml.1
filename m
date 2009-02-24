Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbZBXVqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbZBXVqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 16:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758441AbZBXVqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 16:46:35 -0500
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:64425 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbZBXVqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 16:46:35 -0500
Date: Tue, 24 Feb 2009 15:46:23 -0600
From: Nathan Lynch <ntl@pobox.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Markus Metzger <markus.t.metzger@intel.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@zytor.com, markus.t.metzger@gmail.com,
       srostedt@redhat.com
Subject: Re: [patch 1/6] x86, ftrace, hw-branch-tracer: support hotplug cpus
Message-ID: <20090224154623.0758d692@thinkcentre.lan>
In-Reply-To: <20090224193622.GA26734@elte.hu>
References: <20090119102653.A18774@sedona.ch.intel.com>
 <20090224193622.GA26734@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 99C09BAC-02BC-11DE-BA0D-B26E209B64D9-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009 20:36:22 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Markus Metzger <markus.t.metzger@intel.com> wrote:
> 
> > Support hotplug cpus.
> 
> > +static int __cpuinit bts_hotcpu_handler(struct notifier_block *nfb,
> > +				     unsigned long action, void *hcpu)
> > +{
> > +	unsigned int cpu = (unsigned long)hcpu;
> > +
> > +	mutex_lock(&bts_tracer_mutex);
> 
> This is buggy: CPU hotplug handlers must not sleep (they are 
> called with irqs disabled)

I don't think that is the case; the cpu notifier chains are "raw", not
atomic, and the cpu hotplug core doesn't disable irqs while processing
the chains afaict.  And there are several current examples of cpu
hotplug callbacks performing sleeping operations (slab and slub,
page_alloc, probably many others).

