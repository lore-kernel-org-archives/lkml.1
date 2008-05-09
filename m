Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbYEIFWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbYEIFWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 01:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYEIFW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 01:22:29 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:5136 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752380AbYEIFW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 01:22:27 -0400
Date: Fri, 9 May 2008 14:20:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       bunk@kernel.org, linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       Richard Henderson <rth@twiddle.net>, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       "William L. Irwin" <wli@holomorphy.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] mm: define default cpu_to_node
Message-ID: <20080509052049.GA2161@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
	Richard Henderson <rth@twiddle.net>,
	Paul Mackerras <paulus@samba.org>,
	Anton Blanchard <anton@samba.org>,
	"David S. Miller" <davem@davemloft.net>,
	"William L. Irwin" <wli@holomorphy.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20080508230238.468043000@polaris-admin.engr.sgi.com> <20080508230238.649815000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508230238.649815000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 04:02:39PM -0700, Mike Travis wrote:
>   * Some architectures have CONFIG_NUMA=y but do not define a
>     default cpu_to_node macro.  This provides the default in
>     asm-generic/topology.h but it relies on the fact that
>     cpu_to_node is a defined macro (and not an inline function).
> 
NACK.. This isn't going to work anyways, cpu_to_node() is just where the
first build error occurs. If you do this, then parent_node() is the next
one to blow up, node_to_cpumask() after that, etc, etc. For now I've just
stubbed the asm-generic/topology.h definitions in to asm-sh/topology.h.
