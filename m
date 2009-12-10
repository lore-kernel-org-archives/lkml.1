Return-Path: <linux-kernel-owner+w=401wt.eu-S1761146AbZLJQtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbZLJQtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761128AbZLJQtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:49:01 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57211 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761126AbZLJQtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:49:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eVM0iLMImveJnUId65KW6QZezlcC2DtfaUQSD+Z6SkzlnDydv/OWT23CoCeAQGJL/2
         ZBe8hfwomFZQKLS4hPjRp/h7tDiIpkx2s8xAYpSI/QR8q1CDPjLgolXneTo1N5AsmokQ
         vMyD2GdUk20InUOX7YkQ5u+JWeHJfGViA8asU=
Date: Thu, 10 Dec 2009 19:49:04 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
       linux-kernel@vger.kernel.org, x86team <x86@kernel.org>
Subject: Re: [2.6.32] WARNING: at arch/x86/kernel/apic/apic.c:249
	native_apic_write_dummy+0x30/0x3c()
Message-ID: <20091210164904.GE5086@lenovo>
References: <20091210154837.GT30903@charite.de> <20091210161335.GC5086@lenovo> <20091210163055.GD5086@lenovo> <20091210163745.GA32563@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210163745.GA32563@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 05:37:45PM +0100, Ingo Molnar wrote:
...
> >  
> > +	perfmon_check_apic(&x86_pmu);
> > +
> >  	return 0;
> >  }
> 
> Similar check needed in intel_pmu_init() as well?

Yes (though p6 model already has such a check [fixed by Peter iirc])

>
> Also, i'd suggest to 
> name it pmu_check_apic() or so - and why call it in the middle of of the 
> PMU init functions? All PMU drivers are APIC based, so this call can be 
> done right after:
> 
>         if (err != 0) {
>                 pr_cont("no PMU driver, software events only.\n");
>                 return;
>         }
> 
> 	pmu_check_apic();
> 
> in a single place. Also, no need to pass in &x86_pmu - we have a single 
> PMU driver.
> 
> Thanks,
> 
> 	Ingo
> 

OK, will update and resend. Thanks for comments!

	-- Cyrill
