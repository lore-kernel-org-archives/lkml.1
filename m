Return-Path: <linux-kernel-owner+w=401wt.eu-S1760460AbZBMSuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460AbZBMSuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZBMSun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:50:43 -0500
Received: from smtp-out.google.com ([216.239.45.13]:33486 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZBMSun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:50:43 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=TizaSuAgBihaKjMNIPNp00IQNUhJKlQNRFI5yjYomaaDjKKF2rgFbMWnLMBLAID8C
	diGPn/4KoaYHdnXaoMv3w==
MIME-Version: 1.0
In-Reply-To: <20090213082223.GA4606@elte.hu>
References: <20090212222326.394E121B187@localhost>
	 <20090213082223.GA4606@elte.hu>
Date: Fri, 13 Feb 2009 10:50:39 -0800
Message-ID: <6cc912950902131050g7dcac4ablf2b9e997d3bef148@mail.gmail.com>
Subject: Re: [PATCH] clockevents: avoid unnecessary reprograming of event 
	timer
From: Michael Davidson <md@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mbligh@google.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 12:22 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Hm, given that a good high-res source has nanoseconds resolution,
> what's the chance of this optimization triggering in practice?
> Near zero i think - unless we trigger useless reprogramming without
> having added or removed any new timers - but then we should
> concentrate on analyzing the reason for that redundant reprogramming.
>
> Does it trigger often for you?

Yes - running 2.6.26 built with CONFIG_NO_HZ on a 4 core AMD system,
depending on the workload I see it trigger between 40 and 100 times a second.

I will take a closer look at why this is happening.

md
