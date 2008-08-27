Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYH0B6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYH0B6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 21:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbYH0B6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 21:58:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58768 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbYH0B6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 21:58:33 -0400
Subject: Re: Locking API testsuite: Failures
From: Peter Zijlstra <peterz@infradead.org>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <804dabb00808261727o3ba1f3c0xc25d27ad0694aab4@mail.gmail.com>
References: <804dabb00808261727o3ba1f3c0xc25d27ad0694aab4@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 03:58:31 +0200
Message-Id: <1219802311.6462.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-27 at 08:27 +0800, Peter Teoh wrote:
> [    0.000999] | Locking API testsuite:
> [    0.000999] ----------------------------------------------------------------------------
> [    0.000999]                                  | spin |wlock |rlock
> |mutex | wsem | rsem |
> [    0.000999]
> --------------------------------------------------------------------------
> [    0.000999]                      A-A deadlock:failed|failed|  ok
> |failed|failed|failed|
> [    0.000999]                  A-B-B-A deadlock:failed|failed|  ok
> |failed|failed|failed|
> [    0.000999]              A-B-B-C-C-A deadlock:failed|failed|  ok
> |failed|failed|failed|
> [    0.000999]              A-B-C-A-B-C deadlock:failed|failed|  ok
> |failed|failed|failed|
> [    0.000999]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok
> |failed|failed|failed|
> [    0.000999]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok
> |failed|failed|failed|
> [    0.000999]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok
> |failed|failed|failed|
> [    0.000999]                     double
> unlock:failed|failed|failed|failed|failed|failed|
> [    0.000999]                   initialize
> held:failed|failed|failed|failed|failed|failed|
> [    0.000999]                  bad unlock order:  ok  |  ok  |  ok  |
>  ok  |  ok  |  ok  |
> [    0.000999]
> --------------------------------------------------------------------------
> [    0.000999]               recursive read-lock:             |  ok  |
>             |failed|
> [    0.000999]            recursive read-lock #2:             |  ok  |
>             |failed|
> [    0.000999]             mixed read-write-lock:             |failed|
>             |failed|
> [    0.000999]             mixed write-read-lock:             |failed|
>             |failed|
> [    0.000999]
> --------------------------------------------------------------------------
> [    0.000999]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
> [    0.000999]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
> [    0.000999]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
> [    0.000999]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
> [    0.000999]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
> [    0.000999]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
> [    0.000999]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
> [    0.000999]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
> [    0.000999]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
> [    0.000999]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
> [    0.000999]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
> [    0.000999]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
> 
> truncated....
> 
> I am just curious what does all these failures imply?

Probably that you forgot to enable lockdep ;-)

In which case the error cases fail to produce an error, and the test
fails, but its an expected error, otherwise it would have shouted much
more verbose.



