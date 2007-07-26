Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbXGZEQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbXGZEQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 00:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbXGZEQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 00:16:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44103 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852AbXGZEQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 00:16:10 -0400
Date: Wed, 25 Jul 2007 21:15:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: masouds@google.com (Masoud Asgharifard Sharbiani)
Cc: Andi Kleen <ak@suse.de>, Kirill Korotaev <dev@openvz.org>,
       linux-kernel@vger.kernel.org
Subject: Re: i386-show-unhandled-signals-v3
Message-Id: <20070725211528.03262aa3.akpm@linux-foundation.org>
In-Reply-To: <20070725234005.GA11292@google.com>
References: <20070718154759.GA26425@google.com>
	<46A76210.5020903@openvz.org>
	<200707251657.44217.ak@suse.de>
	<20070725140455.cbbc0dde.akpm@linux-foundation.org>
	<4517d1380707251407v178068baxcc76a86f8337cc27@mail.gmail.com>
	<20070725162528.7d485ff8.akpm@linux-foundation.org>
	<20070725234005.GA11292@google.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 16:40:06 -0700 masouds@google.com (Masoud Asgharifard Sharbiani) wrote:

> This patch makes the i386 behave the same way that x86_64 does when a
> segfault happens. A line gets printed to the kernel log so that tools
> that need to check for failures can behave more uniformly between
> different kernels. Like x86_64, it can be disabled by setting
> debug.show_unhandled_signals sysctl variable to 0 (or by doing
> echo 0 > /proc/sys/debug/show_unhandled_signals)

Is that still correct?  Methinks /proc/sys/debug/exception-trace.

<Looks sadly at Documentation/filesystems/proc.txt>

<Argh, your patch was reversed. Applied with patch -R.>

> Also, all of the lines being printed are now using printk_ratelimit()
> to deny the ability of DoS from a local user with a program like the
> following:
> main()
> {
>        while (1)
>                if (!fork()) *(int *)0 = 0;
> }

yup.
