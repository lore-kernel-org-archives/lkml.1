Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbYKLUoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbYKLUoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYKLUoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:44:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49198 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbYKLUoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:44:30 -0500
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v3][PATCH 0/2] Make ftrace able to trace function return
References: <49191C31.1050402@gmail.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 12 Nov 2008 15:44:03 -0500
In-Reply-To: <49191C31.1050402@gmail.com> (Frederic Weisbecker's message of "Tue, 11 Nov 2008 06:46:25 +0100")
Message-ID: <y0mr65gzncc.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Frederic Weisbecker <fweisbec@gmail.com> writes:

> This patchset adds the ability for ftrace to trace the function even
> on call time and on return time. So we can now measure the time of
> execution of the most part of the functions inside the kernel with
> ftrace. [...]

By the way, one extra complication you may need to deal with, beyond
normal retprobes, is that by the time dyn-ftrace gets hold of the
function entry, some part of the function prologue will have been
executed.  Because the mcount call/sequence is not the first
instruction in the function body, is there a risk that the call frame
cannot be reliably modified because of interference from those first
few other instructions?  Maybe on some architectures/optimization
levels?

- FChE
