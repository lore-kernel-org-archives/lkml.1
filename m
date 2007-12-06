Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbXLFKLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbXLFKLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 05:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbXLFKLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 05:11:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52953 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbXLFKLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 05:11:41 -0500
Date: Thu, 6 Dec 2007 11:11:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch-early-RFC 00/10] LTTng architecture dependent
	instrumentation
Message-ID: <20071206101112.GB17299@elte.hu>
References: <20071206025650.451824066@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071206025650.451824066@polymtl.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi Mathieu,

* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi,
> 
> Here is the architecture dependent instrumentation for LTTng. [...]

A fundamental observation about markers, and i raised this point many 
many months ago already, so it might sound repetitive, but i'm unsure 
wether it's addressed. Documentation/markers.txt still says:

| * Purpose of markers
|
| A marker placed in code provides a hook to call a function (probe) 
| that you can provide at runtime. A marker can be "on" (a probe is 
| connected to it) or "off" (no probe is attached). When a marker is 
| "off" it has no effect, except for adding a tiny time penalty 
| (checking a condition for a branch) and space penalty (adding a few 
| bytes for the function call at the end of the instrumented function 
| and adds a data structure in a separate section).

could you please eliminate the checking of the flag, and insert a pure 
NOP sequence by default (no extra branches), which is then patched in 
with a function call instruction sequence, when the trace point is 
turned on? (on architectures that have code patching infrastructure - 
such as x86)

	Ingo
