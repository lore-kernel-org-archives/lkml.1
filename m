Return-Path: <linux-kernel-owner+w=401wt.eu-S933627AbYDQSU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627AbYDQSU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 14:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757085AbYDQSUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 14:20:12 -0400
Received: from ns2.suse.de ([195.135.220.15]:40527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756869AbYDQSUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 14:20:10 -0400
Message-ID: <480794D4.9020503@suse.de>
Date: Thu, 17 Apr 2008 20:20:04 +0200
From: Stefan Seyfried <seife@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.8.1.12) Gecko/20071114 SUSE/2.0.0.12-14 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Romano Giannetti <romanol@upcomillas.es>
Cc: Soeren Sonnenburg <kernel@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       suspend-devel@lists.sourceforge.net,
       Jesse Barnes <jesse.barnes@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Suspend-devel] 2.6.25-rc6 regression - hang on resume [Bug	10319]
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>	<pdYe6zNQVl.A.fp.nEW9HB@albercik> <1207290689.4511.1.camel@localhost> <1207552602.26185.13.camel@pern>
In-Reply-To: <1207552602.26185.13.camel@pern>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Romano Giannetti schrieb:
> 
> On Fri, 2008-04-04 at 08:31 +0200, Soeren Sonnenburg wrote:
>> On Fri, 2008-04-04 at 01:22 +0200, Rafael J. Wysocki wrote:
> 
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10319
>>> Subject		: 2.6.25-rc6 regression - hang on resume
>>> Submitter	: Soeren Sonnenburg <kernel@nn7.de>
>>> Date		: 2008-03-25 04:44 (10 days old)
>> Yes. The machine resumes and display stays black using s2ram -f -p
>> (blindly typing reboot etc on keyboard does what is expected). However
>> display comes back on 2.6.24.
> 
> I can add that on my laptop (toshiba U305, Intel 945GM chipset), s2ram
> -f -p -m which used to work ok, in X and console, in 2.6.24 stopped to
> work (I tested -rc8, but I think it's like that since a long time).
> Machine resumes but the screen stays off after that, although machine is
> working (exactly as Soeren said). 

can you try if this patch to libx86 (make sure it gets installed and used...)
fixes the problem?

Index: libx86-0.99/x86-common.c
===================================================================
--- libx86-0.99.orig/x86-common.c
+++ libx86-0.99/x86-common.c
@@ -232,7 +232,7 @@ int LRMI_common_init(void)
 	}

 	m = mmap((void *)0xa0000, 0x100000 - 0xa0000,
-	 PROT_READ | PROT_WRITE,
+	 PROT_READ | PROT_WRITE | PROT_EXEC,
 	 MAP_FIXED | MAP_SHARED, fd_mem, 0xa0000);

 	if (m == (void *)-1) {

> On the other hand, now the plain "echo mem > /sys/power/state" works
> perfectly, from X and console. So some of the magic vbe save/restore of
> s2ram mess something up for this card. 

Especially the userspace stuff (VBE_*) should not interfere with the restoring
now done inside the kernel drivers.

> Is it a regression for my laptop (is evidently one for Soeren)? On one
> side, a "used to work" setup is broken, but it worked with userspace
> hacks; now it works with the plain way, and that's clearly better.
-- 
Stefan Seyfried
R&D Team Mobile Devices            |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg | "Well, surrounding them's out."

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
