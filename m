Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbXGaK4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbXGaK4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbXGaK4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:56:35 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58160 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbXGaK4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:56:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATH 0/1] Kexec jump - v2 - the first step to kexec based hibernation
References: <1184483593.1898.98.camel@caritas-dev.intel.com>
	<20070731091004.GA2022@elf.ucw.cz>
	<1185873924.23149.86.camel@caritas-dev.intel.com>
Date: Tue, 31 Jul 2007 04:52:35 -0600
In-Reply-To: <1185873924.23149.86.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Tue, 31 Jul 2007 17:25:24 +0800")
Message-ID: <m17iogrgjw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> On Tue, 2007-07-31 at 11:10 +0200, Pavel Machek wrote:
>> > Index: kexec-tools-1.101/kexec/arch/i386/crashdump-x86.c
>> > ===================================================================
>> > --- kexec-tools-1.101.orig/kexec/arch/i386/crashdump-x86.c 2007-07-08
> 23:00:25.000000000 +0800
>> > +++ kexec-tools-1.101/kexec/arch/i386/crashdump-x86.c 2007-07-14
> 17:06:45.000000000 +0800
>> > @@ -428,6 +428,29 @@
>> >  	return 0;
>> >  }
>> >  
>> > +/* Adds the kexec_backup= command line parameter to command line. */
>> > +static int cmdline_add_backup(char *cmdline, unsigned long addr)
>> > +{
>> > +	int cmdlen, len, align = 1024;
>> > +	char str[30], *ptr;
>> > +
>> > +	/* Passing in kexec_backup=xxxK format. Saves space required
>> > +	 * in cmdline. Ensure 1K alignment*/
>> > +	if (addr%align)
>> > +		return -1;
>> > +	addr = addr/align;
>> > +	ptr = str;
>> > +	strcpy(str, " kexec_backup=");
>> > +	ptr += strlen(str);
>> > +	ultoa(addr, ptr);
>> > +	strcat(str, "K");
>> > +	len = strlen(str);
>> > +	cmdlen = strlen(cmdline) + len;
>> > +	if (cmdlen > (COMMAND_LINE_SIZE - 1))
>> > +		die("Command line overflow\n");
>> > +	strcat(cmdline, str);
>> > +	return 0;
>> > +}
>> 
>> This part did not apply for me -- it seems crashdump related and I did
>> not have that applied. Is it critical?
>
> This is needed for kexec_jump to work properly. Which version of
> kexec-tools do you use? This patch is against 1.101. The kdump patch
> must be applied before this patch is applied.

Please work against the kexec-tools-testing tree, if you can.
All of the outstanding patches should be there.

Eric
