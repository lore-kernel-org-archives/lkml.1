Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbYJaQvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbYJaQvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYJaQv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:51:26 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:39855 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbYJaQvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:51:25 -0400
X-SourceIP: 213.46.9.244
Subject: Re: sched domains oddness.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20081031162443.GA29885@redhat.com>
References: <20081031162443.GA29885@redhat.com>
Content-Type: text/plain
Date: Fri, 31 Oct 2008 17:51:51 +0100
Message-Id: <1225471911.7803.1596.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-31 at 12:24 -0400, Dave Jones wrote:
> The attached dmesg comes from my dual core laptop running 2.6.27
> What's up with all the sched domains transitions at the bottom?
> This was just a boot up from power off, no suspend/resume or anything funky.

> CPU0 attaching NULL sched-domain.
> CPU1 attaching NULL sched-domain.
> CPU0 attaching sched-domain:
>  domain 0: span 0-1 level MC
>   groups: 0 1
>   domain 1: span 0-1 level NODE
>    groups: 0-1
> CPU1 attaching sched-domain:
>  domain 0: span 0-1 level MC
>   groups: 1 0
>   domain 1: span 0-1 level NODE
>    groups: 0-1

3x

looks like someone is triggering rebuild_sched_domains(), is something
poking cpusetfs files or flipping between sched_mc settings?

