Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbZDLSAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbZDLSAi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 14:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbZDLSA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 14:00:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:40854 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbZDLSA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 14:00:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HN3hAHcuccmL+AitLbGVzh9+BDlZta815taluXgkIslRO8o+SfFUpRX4EsQgqvLT6c
         Pcu/fKmuhl4RJpuBNDv/WS/6o/OR+0k79PLN9b1gMTPb6p+5K/aJITvcGec6jsq93RWW
         hKRwHZIVffQhvhGvBxJFtvj2Q8yi5nSze4HtQ=
Date: Sun, 12 Apr 2009 22:00:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa@zytor.com, tglx@linutronix.de, xemul@openvz.org, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org, macro@linux-mips.org, andi@firstfloor.org
Subject: Re: [rfc 0/4] x86 - apic dummy ops with cleanups
Message-ID: <20090412180014.GD6942@lenovo>
References: <20090412164738.967602112@openvz.org> <20090412172431.GA26459@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090412172431.GA26459@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Apr 12, 2009 at 07:24:31PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
| 
| > Hi,
| > 
| > here is a series of patches with some tiny
| > cleanup and one bugfix I believe (and most
| > probably why fixing one issue new one could
| > be introduced as well :-)
| > 
| > Please review and test if possible. _Any_ kind
| > of feedback is highly appreciated!
| 
| This series looks very good and is well-structured,
| i've applied it to tip:x86/apic and started testing
| it, thanks Cyrill!
| 
| 	Ingo
| 

Thanks, Ingo!

Actually I found one a bit suspicious thing (not sure if it was
initially designed to  behave like that).

Suppose we have SMP compiled kernel and even supported on HW
level but then we disable apic thru kernel option. And then
when system startup it should be working fine since we go
to uniprocessor mode. Then the machine going for reboot and we have:

Starting from arch/x86/kernel/reboot.c

native_machine_shutdown
	smp_send_stop
		smp_ops.smp_send_stop
			native_smp_send_stop
				disable_local_APIC
					apic_write(APIC_SPIV, value);

Since we have reserved APIC memory mapped area (in _anycase_)
it doesn't cause any problems but was it initially supposed?

Most probably I miss something.

        Cyrill
