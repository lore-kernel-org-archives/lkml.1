Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbZKSRN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbZKSRN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbZKSRN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:13:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:36476 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbZKSRNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:13:55 -0500
Subject: Re: [PATCH 2/2] lockdep: Don't only check recursive read locks
 once in a sequence
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ming Lei <tom.leiming@gmail.com>
In-Reply-To: <20091119155549.GB4967@nowhere>
References: <1258506398-5151-1-git-send-email-fweisbec@gmail.com>
	 <1258506398-5151-3-git-send-email-fweisbec@gmail.com>
	 <4B03C1A7.4070305@cn.fujitsu.com>  <20091119155549.GB4967@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Nov 2009 18:13:48 +0100
Message-ID: <1258650828.3931.437.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 16:55 +0100, Frederic Weisbecker wrote:
> And btw I
> don't understand why rwsem read locks are not considered as
> recursive in lockdep. 

Because they're not.

rwsems are FIFO fair, so a double read can deadlock when there's a
pending writer inbetween.

