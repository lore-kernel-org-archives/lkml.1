Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbXC2Nbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbXC2Nbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 09:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbXC2Nbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 09:31:33 -0400
Received: from hu-out-0506.google.com ([72.14.214.236]:61503 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbXC2Nba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 09:31:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Tx3B0Y61VMHOneFTC56jriKexWc1Mz9I8tIwvPuv5nPu9Y2l8/79wRonhXvh0i5eoNWExGO2Gzjtl34LXGGCxupUOkvLp/gjXthgDz4vfHPObGUs6qYfnwkc7zsNZk2upAScEPC3v6JSPmNDZ0B6xkhL/PVvmAFJQ5vxP/I2aNU=
From: Maxim <maximlevitsky@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [ PATCH] Add suspend/resume for HPET was: Re: [3/6] 2.6.21-rc4: known regressions
Date: Thu, 29 Mar 2007 15:31:17 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703290747.28929.maximlevitsky@gmail.com> <460BBD1B.4040308@ru.mvista.com>
In-Reply-To: <460BBD1B.4040308@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703291531.18253.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2007 15:20:27 Sergei Shtylyov wrote:
> Hello.
> 
> Maxim wrote:
> 
> > ---
> > This adds support of suspend/resume on i386 for HPET
> 
>    The part after usually "---" gets cut off, the patch description and 
> signoff should actially *precede* it.
> 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> 
> > diff --git a/arch/i386/kernel/hpet.c b/arch/i386/kernel/hpet.c
> > index 0fd9fba..7c67780 100644
> > --- a/arch/i386/kernel/hpet.c
> > +++ b/arch/i386/kernel/hpet.c
> [...]
> > +static __init int hpet_register_sysfs(void)
> > +{
> > +	int err;
> > +
> > +	if (!is_hpet_capable())
> > +		return 0;
> > +
> > +	err = sysdev_class_register(&hpet_class);
> > +
> > +	if (!err) {
> > +		sysdev_register(&hpet_device);
> > +		if (err)
> > +			sysdev_class_unregister(&hpet_class);
> 
>     This doesn't make sense, err will always be 0.  Perhaps you actually 
> intended to check the result of sysdev_register()?
> 
> > +	}
> > +
> > +	return err;
> > +}
> > +
> > +device_initcall(hpet_register_sysfs);
> > +
> > +#endif
> 
> WBR, Sergei
> 

Hi,
	Big thanks for pointing this out,
		I will resend that updated patch.

	Best regards,
		Maxim Levitsky

