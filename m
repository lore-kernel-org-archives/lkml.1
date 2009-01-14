Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbZANHDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbZANHDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbZANHC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:02:57 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:58697 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbZANHC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:02:57 -0500
Message-ID: <496D8E0D.5090401@knaff.lu>
Date: Wed, 14 Jan 2009 08:02:37 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: The policy on initramfs decompression failure
References: <496D17F9.8080605@zytor.com> <496D20FB.5010307@knaff.lu> <20090114054022.GA11153@elte.hu>
In-Reply-To: <20090114054022.GA11153@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> And your argument makes little sense: if there is something wrong then one 
> looks at the logs _anyway_.

Unfortunately, not everybody has the knowledge or equipment ready to set
up a serial console... And logs in the classical sense (in a logfile...)
don't exist yet at that early stage of boot, because it happens _before_
the kernel is able to write to the filesystem...

> Are you suggesting that all warnings that 
> signal some potential badness should result in a panic? That is 
> nonsensical.

There must be some misunderstanding somewhere. I didn't make any such
suggestion. I agree with you, such a suggestion would be nonsensical.

> What you seem to be arguing for is to introduce a kernel option that says 
> "panic on warnings" - so that folks cannot miss warnings. _That_ would be 
> a fair argument.

That would be an interesting idea, but might lead to the opposite
problem (kernel stopping _before_ the real problem happens).

Maybe what we could do is "fix" panic() such that it doesn't disable
Shift-Pgup. But I admit that such a change may not be trivial to
implement, as there may be cases where the interrupt system is fubar,
and all interrupt handlers (including keyboard) would need to be disabled.

> Panics are rarely good, unless the user asks for it, period. We've been 
> flipping over BUG_ON()s to WARN_ON() everywhere where it matters in 
> practice.
> 
> 	Ingo

That is a valid philosophical discussion. But shouldn't we move it to a
thread of its own?

Regards,

Alain
