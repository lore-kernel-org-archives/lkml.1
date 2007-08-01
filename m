Return-Path: <linux-kernel-owner+w=401wt.eu-S1764005AbXHABQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764005AbXHABQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759013AbXHABQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:16:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:41671 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758394AbXHABQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:16:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,206,1183359600"; 
   d="scan'208";a="111998890"
Subject: Re: [PATH 0/1] Kexec jump - v2 - the first step to kexec based
	hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <m17iogrgjw.fsf@ebiederm.dsl.xmission.com>
References: <1184483593.1898.98.camel@caritas-dev.intel.com>
	 <20070731091004.GA2022@elf.ucw.cz>
	 <1185873924.23149.86.camel@caritas-dev.intel.com>
	 <m17iogrgjw.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 01 Aug 2007 09:16:13 +0800
Message-Id: <1185930973.1363.1.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 01 Aug 2007 01:16:21.0993 (UTC) FILETIME=[9257A590:01C7D3D9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 04:52 -0600, Eric W. Biederman wrote:
> "Huang, Ying" <ying.huang@intel.com> writes:
> 
> > On Tue, 2007-07-31 at 11:10 +0200, Pavel Machek wrote:
> >> > Index: kexec-tools-1.101/kexec/arch/i386/crashdump-x86.c
> >> > ===================================================================
> >> > --- kexec-tools-1.101.orig/kexec/arch/i386/crashdump-x86.c 2007-07-08
> > 23:00:25.000000000 +0800
> >> > +++ kexec-tools-1.101/kexec/arch/i386/crashdump-x86.c 2007-07-14
> > 17:06:45.000000000 +0800
> >> > @@ -428,6 +428,29 @@
> >> >  	return 0;
> >> >  }
> >> >  
> >> > +/* Adds the kexec_backup= command line parameter to command line. */
> >> > +static int cmdline_add_backup(char *cmdline, unsigned long addr)
> >> > +{
> >> > +	int cmdlen, len, align = 1024;
> >> > +	char str[30], *ptr;
> >> > +
> >> > +	/* Passing in kexec_backup=xxxK format. Saves space required
> >> > +	 * in cmdline. Ensure 1K alignment*/
> >> > +	if (addr%align)
> >> > +		return -1;
> >> > +	addr = addr/align;
> >> > +	ptr = str;
> >> > +	strcpy(str, " kexec_backup=");
> >> > +	ptr += strlen(str);
> >> > +	ultoa(addr, ptr);
> >> > +	strcat(str, "K");
> >> > +	len = strlen(str);
> >> > +	cmdlen = strlen(cmdline) + len;
> >> > +	if (cmdlen > (COMMAND_LINE_SIZE - 1))
> >> > +		die("Command line overflow\n");
> >> > +	strcat(cmdline, str);
> >> > +	return 0;
> >> > +}
> >> 
> >> This part did not apply for me -- it seems crashdump related and I did
> >> not have that applied. Is it critical?
> >
> > This is needed for kexec_jump to work properly. Which version of
> > kexec-tools do you use? This patch is against 1.101. The kdump patch
> > must be applied before this patch is applied.
> 
> Please work against the kexec-tools-testing tree, if you can.
> All of the outstanding patches should be there.

OK, I will work against the kexec-tools-testing tree in the next
version.

Best Regards,
Huang Ying
