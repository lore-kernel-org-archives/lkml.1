Return-Path: <linux-kernel-owner+w=401wt.eu-S965388AbXDBKXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965388AbXDBKXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 06:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965380AbXDBKXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 06:23:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:17103 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965388AbXDBKXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 06:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=FHxWg4CLnqpEiuV+ZNFLSFpNtOW4tHa8GDjZro9QMR/V7GVWHjUTOBBSlBfF9aib06usPgf9Ocek/XV8VTx7QqG8/32myn7xXzsyDLDOoDi5w8mAsfySan0XdXtPALZ/nkxUHgP7GQwaWG6+A6egVNOxWRXws3GZ8yXrpEZR3T0=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: tglx@linutronix.de
Subject: Re: Clockevents: one-shoot mode is never enabled if local apic timer is disabled
Date: Mon, 2 Apr 2007 13:23:45 +0300
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200704021157.03368.maximlevitsky@gmail.com> <1175506484.28263.101.camel@localhost.localdomain>
In-Reply-To: <1175506484.28263.101.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704021323.45585.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 12:34:44 Thomas Gleixner wrote:
> Maxim,
> 
> can you please fix your mail client to do proper line wraps at 78
> chars ?
Sure, but this way it mangles patches :-)
> 
> On Mon, 2007-04-02 at 11:57 +0300, Maxim Levitsky wrote:
> > Hi,
> > 
> > I finally figured out why one-shoot mode is enabled on my system only
> > and only if local apic is enabled.
> 
> You could have asked me :)
Thanks
> 
> > I tried to remove this check and this resulted in hard lock-up during
> > boot with nolapic_timer
> > Maybe this was connected to the fact that this function is called on
> > both cpus, and if one set a 
> > broadcasting device(HPET) to one shoot mode, second is still not aware
> > of this.
> > 
> > Is it a bug or feature ?
> 
> One shot mode - used for NO_HZ and HIGH_RES - requires a working per cpu
> timer.
> 
> When you disable the lapic timers, then we register the lapic timers
> just as dummy devices to utilize the broadcast mechanism. Otherwise the
> second CPU would be not working at all. I decided not to enable
> nohz/highres when we have no usable per cpu devices available. 
> 
> So consider it a feature :)
> 
> 	tglx
> 
> 
> 
Hi, 

Fortunately on my system lapic timer works.
But then tick_broadcast_switch_to_oneshot is redundant, isn't it? 

Thanks for quick answer,
	Best regards,
		Maxim Levitsky

