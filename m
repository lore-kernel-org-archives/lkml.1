Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab0BQXaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 18:30:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57961 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829Ab0BQXad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 18:30:33 -0500
Message-ID: <4B7C7BE4.9050908@zytor.com>
Date: Wed, 17 Feb 2010 15:29:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Zachary Amsden <zamsden@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] x86 rwsem optimization extreme
References: <1266443901-3646-1-git-send-email-zamsden@redhat.com> <alpine.LFD.2.00.1002171403160.4141@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002171403160.4141@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2010 02:10 PM, Linus Torvalds wrote:
> 
> The cost of 'adc' may happen to be identical in this case, but I suspect 
> you didn't test on UP, where the 'lock' prefix goes away. An unlocked 
> 'add' tends to be faster than an unlocked 'adc'.
> 
> (It's possible that some micro-architectures don't care, since it's a 
> memory op, and they can see that 'C' is set. But it's a fragile assumption 
> that it would always be ok).
> 

FWIW, I don't know of any microarchitecture where adc is slower than
add, *as long as* the setup time for the CF flag is already used up.
However, as I already commented, I don't think this is worth it.  This
inline appears to only be instantiated once, and as such, it takes a
whopping six bytes across the entire kernel.

	-hpa

