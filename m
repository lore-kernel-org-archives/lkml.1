Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbZG0SM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbZG0SM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZG0SM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:12:26 -0400
Received: from smtp-out.google.com ([216.239.33.17]:14630 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbZG0SMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:12:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=sdgePkGvq5HNEo3zA/BuA+GziQ5k6x0j4umSeLREMfoaEtUHZGuwhMBO6nHjqwaFT
	Tx0Z9QKIMH5qp7OsDALrw==
Date: Mon, 27 Jul 2009 11:12:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Gregory Haskins <gregory.haskins@gmail.com>
cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [regression] sched_getaffinity fails with EINVAL in 2.6.31-rc4
In-Reply-To: <4A6DE0DC.2070207@gmail.com>
Message-ID: <alpine.DEB.2.00.0907271108350.8408@chino.kir.corp.google.com>
References: <4A6DE0DC.2070207@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009, Gregory Haskins wrote:

> I am not sure when this started, but noticed that sched_getaffinity is
> not working in -rc4.
> 
> [pid  6254] sched_getaffinity(0, 128, 0x7f80586b1fe0) = -1 EINVAL
> (Invalid argument)
> 
> Here is a simple program for reproduction:
> 
> #include <sched.h>
> 
> int main(void)
> {
> 	cpu_set_t mask;
> 	int ret;
> 
> 	ret = sched_getaffinity(0, sizeof(mask), &mask);
> 	if (ret < 0)
> 		perror("getaffinity");
> 
> 	return ret;
> }
> 
> If I get time, I will bisect this later today.
> 

It's most likely due to the cpumask changes.  I don't know what cpu_set_t 
is, but it's probably smaller than CONFIG_NR_CPUS rounded up to a multiple 
of sizeof(long).
