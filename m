Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYHCGyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYHCGyi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 02:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYHCGy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 02:54:29 -0400
Received: from gw.goop.org ([64.81.55.164]:37307 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbYHCGy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 02:54:28 -0400
Message-ID: <4895561C.2030004@goop.org>
Date: Sat, 02 Aug 2008 23:54:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: Restore the proper NR_IRQS define so larger systems
 work.
References: <1217642575-22727-1-git-send-email-yhlu.kernel@gmail.com>	<m18wveacu6.fsf@frodo.ebiederm.org>	<86802c440808022258x1198093x7d21274b82e75f4b@mail.gmail.com> <m1sktm7ght.fsf@frodo.ebiederm.org>
In-Reply-To: <m1sktm7ght.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Xen pv 64 will work at least as well with a larger definition for
> NR_IRQS as it will work with a smaller definition, and since
> NR_VECTORS is 256 we always have more irqs with the 32bit definition
> we were mistakenly using. 
>
> Xen has 1024 event channels so I expect 1024 would the nice number to
> provide there.
>   

Yes, but really its overkill.  It needs about 6 interrupts/cpu for 
normal system overhead (timer, IPI, things like that), and then some 
amount for virtual devices.

dom0 - the control domain - will need some number of events per other 
guest domain, so it can start feeling the pressure depending on how many 
domains and devices there are.

    J
