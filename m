Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbXGaLML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbXGaLML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 07:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbXGaLL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 07:11:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35705 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755365AbXGaLL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 07:11:57 -0400
Date: Tue, 31 Jul 2007 13:12:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATH 0/1] Kexec jump - v2 - the first step to kexec based hibernation
Message-ID: <20070731111208.GA1778@elf.ucw.cz>
References: <1184483593.1898.98.camel@caritas-dev.intel.com> <20070731091004.GA2022@elf.ucw.cz> <1185873924.23149.86.camel@caritas-dev.intel.com> <m17iogrgjw.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17iogrgjw.fsf@ebiederm.dsl.xmission.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

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

So
git://git.kernel.org/pub/scm/linux/kernel/git/horms/kexec-tools-testing.git
is the right tree to use?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
