Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbZIXOsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbZIXOsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbZIXOsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:48:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:56695 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbZIXOsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:48:13 -0400
Subject: Re: [PATCH 1/2] itimers: fix racy writes to cpu_itimer fields
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1253802903-979-1-git-send-email-sgruszka@redhat.com>
References: <1253802903-979-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 16:48:07 +0200
Message-Id: <1253803687.18939.26.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 16:35 +0200, Stanislaw Gruszka wrote:
> incr_error and error fields of struct cpu_itimer are used when calculating
> next timer tick in check_cpu_itimers() and should not be modified without
> tsk->sighand->siglock taken.

Won't it be all-round much better to convert these things to hrtimers
instead of adding more and more fuzz on top to make them deal with
jiffies?

