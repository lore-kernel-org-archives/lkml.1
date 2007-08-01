Return-Path: <linux-kernel-owner+w=401wt.eu-S1762183AbXHAH4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762183AbXHAH4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 03:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759724AbXHAH4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 03:56:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:40590 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759419AbXHAH4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 03:56:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,207,1183359600"; 
   d="scan'208";a="257225598"
Subject: Re: [PATH 1/1] Kexec jump - v2 - kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20070731095101.GA1774@elf.ucw.cz>
References: <1184483639.1898.99.camel@caritas-dev.intel.com>
	 <20070731095101.GA1774@elf.ucw.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 01 Aug 2007 15:56:18 +0800
Message-Id: <1185954978.1363.23.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 01 Aug 2007 07:56:26.0611 (UTC) FILETIME=[7635AC30:01C7D411]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 11:51 +0200, Pavel Machek wrote:
> Hi!
> 
> > This patch implement the functionality of jumping from kexeced kernel
> > to original kernel.
> > 
> > A new reboot command named LINUX_REBOOT_CMD_KJUMP is defined to
> > trigger the jumping to (executing) the new kernel or jumping back to
> > the original kernel.
> 
> Could we get two reboot commands? Exec loaded kernel seems to be quite
> different operation than "jump back".

Exec loaded kernel for jumping back is also different from exec loaded
kernel normally.

Maybe the two reboot operations in kexec jump can be seen as "jump to"
and "jump back"?

> How do I test these patches? kexec -p <bzImage>, then kexec -j?

Yes.

> > +static unsigned long kexec_backup_addr = ~0UL;
> > +
> > +/* kexec_backup= specifies the location of backuped 0~640k memory of
> > + * crashed kernel.
> > + */
> > +static int __init parse_kexec_backup(char *arg)
> > +{
> > +	if (!arg)
> > +		return -EINVAL;
> > +
> > +	kexec_backup_addr = memparse(arg, &arg);
> > +	return 0;
> > +}
> > +early_param("kexec_backup", parse_kexec_backup);
> 
> New kernel parameters should be documented. (Plus I do not know how to
> use this one, please help :-).

This kernel parameter will be added to kernel command line by
kexec-tools automatically.

I will add corresponding document in next version.

> 
> > +int kexec_flags;
> > +
> > +static unsigned long kexec_jump_buf_pfn;
> > +
> > +static int __init parse_kexec_jump_buf_pfn(char *arg)
> > +{
> > +	if (!arg)
> > +		return -EINVAL;
> > +
> > +	kexec_jump_buf_pfn = memparse(arg, &arg);
> > +	kexec_flags |= KEXEC_FLAGS_IS_KEXECED_KERNEL;
> > +	return 0;
> > +}
> > +early_param("kexec_jump_buf_pfn", parse_kexec_jump_buf_pfn);
> 
> This one should be documented, too, I'd guess. (Is that internal,
> kernel-to-kernel communication?)

Document will be added in next version too.

This parameter is used for kernel-to-kernel communication. But now, it
must be setup by user, as in usage guide.

Best Regards,
Huang Ying
