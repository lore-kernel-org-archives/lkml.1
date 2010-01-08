Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051Ab0AHTLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0AHTLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 14:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928Ab0AHTLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 14:11:21 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54328 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab0AHTLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 14:11:20 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86: update nr_irqs according cpu num
References: <1262951595-1729-1-git-send-email-yinghai@kernel.org>
	<1262951595-1729-5-git-send-email-yinghai@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 08 Jan 2010 11:11:14 -0800
In-Reply-To: <1262951595-1729-5-git-send-email-yinghai@kernel.org> (Yinghai Lu's message of "Fri\, 08 Jan 2010 03\:53\:15 -0800")
Message-ID: <m1bph4o1il.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> that is max number on run time.

Ouch!  Unless I misread this code this will leave nr_irqs at
NR_IRQS_LEGACY. aka 16.

Let's do something stupid and simple.
nr_irqs = nr_cpus_ids * 256;  /* Semi-arbitrary number */

Ideally we would set "nr_irqs = 0x7fffffff;" but we have just enough
places using nr_irqs that I think those loops would get painful if we
were to do that.

Eric
