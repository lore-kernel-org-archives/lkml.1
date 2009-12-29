Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbZL2CCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbZL2CCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 21:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbZL2CCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 21:02:18 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39310 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZL2CCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 21:02:18 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B3961B4.9000405@s5r6.in-berlin.de>
Date: Tue, 29 Dec 2009 02:56:04 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091025 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jay Fenlason <fenlason@redhat.com>
Subject: Re: On "ratelimit: Use per ratelimit context locking"
References: <4B2E0CFB.30806@s5r6.in-berlin.de> <20091228095314.GI24690@elte.hu>
In-Reply-To: <20091228095314.GI24690@elte.hu>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> There used to be a global lock:
> 
>   static DEFINE_SPINLOCK(ratelimit_lock);
> 
> which is now per ratelimit context. The case i was after was to use the 
> ratelimit state from NMI context. With NMIs we can lock up if an NMI hits when 
> some other code uses the ratelimit code. It's a small but existing race 
> window.

Ah, I see.

> OTOH, IRQ context use of printk ratelimit was safe before (and after) this 
> commit - so i think your code should be safe too.

Thanks for the explanation; that's reassuring.
-- 
Stefan Richter
-=====-==--= ==-- ===-=
http://arcgraph.de/sr/
