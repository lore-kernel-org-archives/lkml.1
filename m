Return-Path: <linux-kernel-owner+w=401wt.eu-S1759355AbYENDce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355AbYENDce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 23:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757194AbYENDcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 23:32:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:32423 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755878AbYENDcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 23:32:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,483,1204531200"; 
   d="scan'208";a="383503240"
Subject: Re: [PATCH] kexec based hibernation: a prototype of kexec
	multi-stage load
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080514025607.GA19944@redhat.com>
References: <1210574441.30365.8.camel@caritas-dev.intel.com>
	 <20080513053408.GA5870@redhat.com>
	 <1210730266.23707.50.camel@caritas-dev.intel.com>
	 <20080514025607.GA19944@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 14 May 2008 11:37:55 +0800
Message-ID: <1210736275.23707.62.camel@caritas-dev.intel.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 14 May 2008 03:31:34.0759 (UTC) FILETIME=[027BBF70:01C8B573]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-13 at 22:56 -0400, Vivek Goyal wrote:
[...]
> > 
> > > Last time I tried the patches (V9) and kexec jump did not work for me. I
> > > was not getting timer interrupts in second kernel. Then I had to put 
> > > LAPIC and IOAPIC in legacy mode and then at one way jump started working.
> > > I am not sure how the next kernel boots for you without putting APICs
> > > in legacy mode. (Yet to make returning back to original kernel work
> > > using V9). 
> > 
> > Can normal kexec (without kexec jump) works without putting LAPIC and
> > IOAPIC in legacy mode? Does this mean we should put LAPIC and IOAPIC
> > into legacy mode before kexec and restore them after?
> > 
> 
> We do put LAPIC and IOAPIC in legacy mode in normal kexec. Look at 
> disable_IO_APIC() in native_machine_shutdown(). So I think we shall
> have to do the same thing in kexec jump code too.

OK. I will look at this.

> I went through above mail thread again where we were discussing what all
> information need to be passed between kernels.
> 
> Last time we enumerated three things.
> 
> - kernel entry/re-entry point for switch between kernels.
> - backup pages map for core filtering
> - Probably ELF core notes for saving hibernated image.
> 
> I think if we just implement the functionality so that one can switch
> back and forth between kernels (no hibernated image saving),then we probably
> need to pass around only kernel entry/re-entry point and nothing else and in
> your patches I think you are already doing using %edi.

Yes.

> So, IMHO, for first simple implementation, we don't have to pass around
> any data between kernels except entry point. (Please correct me if I am 
> wrong). Lets get that implementation in first and then we can get rest
> of the pieces in place.

Yes. Kernel entry/re-entry point is the only information need to be
communicated between kernels for just switching between them. So we can
focus on kexec jump patch firstly.

Best Regards,
Huang Ying

