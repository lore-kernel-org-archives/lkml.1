Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbYE1Beo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbYE1Beo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 21:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbYE1Bee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 21:34:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:16860 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992AbYE1Bed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 21:34:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,551,1204531200"; 
   d="scan'208";a="285552222"
Subject: Re: [PATCH -mm] kexec jump -v9
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080527221514.GA20037@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	 <20080514205204.GJ30469@redhat.com>
	 <1210830110.23707.141.camel@caritas-dev.intel.com>
	 <20080516005121.GA6926@redhat.com>
	 <1211873263.12819.103.camel@caritas-dev.intel.com>
	 <20080527221514.GA20037@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 28 May 2008 09:35:52 +0800
Message-Id: <1211938552.12819.122.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 28 May 2008 01:34:31.0252 (UTC) FILETIME=[F9EE2140:01C8C062]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-27 at 18:15 -0400, Vivek Goyal wrote:
[...]
> > But, because IOAPIC may need to be in original state during
> > suspend/resume, so it is not appropriate to call disable_IO_APIC() in
> > ioapic_suspend(). So I think we can call disable_IO_APIC() in new
> > hibernation/restore callback.
> 
> My hunch is suspend/resume will still work if we put this call in
> ioapic_suspend() but I would not recommend that. suspend/resume does
> not need to put IOAPIC in legacy mode.
>   
> I am not sure what is "new hibernation/restore callback"? Are you
> referring to new patches from Rafel?

Yes. Rafel has a new patch to separate suspend and hibernation device
call backs.
http://kerneltrap.org/Linux/Separating_Suspend_and_Hibernation

> I think this issue is specifc to kexec and kjump so probably we should
> not tweaking any suspend/resume related bit.
> 
> How about calling disable_IO_APIC() in kexec_jump()? We can probably even
> optimize it by calling it only when we are transitioning into new image
> for the first time and not for subsquent transitions (by keeping some kind of
> count in kimage). This is little hackish but, should work...

Yes. This issue is kexec/kjump specific. We can call it in kexec_jump().
Maybe we also need call something other in native_machine_shutdown()?

BTW: I have a new version -v10: http://lkml.org/lkml/2008/5/22/106, do
you have time to review it?

Best Regards,
Huang Ying
