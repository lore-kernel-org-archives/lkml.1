Return-Path: <linux-kernel-owner+w=401wt.eu-S937745AbXG3Rbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937745AbXG3Rbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758104AbXG3Rb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:31:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:40837 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219AbXG3Rb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:31:26 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Danny ter Haar <dth@dth.net>
Subject: Re: Update: ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not:
Date: Mon, 30 Jul 2007 13:30:54 -0400
User-Agent: KMail/1.9.5
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20070727193832.GA20289@dth.net> <46AC0F6E.2000008@googlemail.com> <20070730025412.GA22888@dth.net>
In-Reply-To: <20070730025412.GA22888@dth.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707301330.54640.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 July 2007 22:54, Danny ter Haar wrote:
> Quoting Gabriel C (nix.or.die@googlemail.com):
> > Now while we think is ACPI this should be easy for you to bisect.
> > This commit http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=39804b20f62532fa05c2a8c3e2d1ae551fd0327b
> > merged ACPI so this one should be your first bad one.
> > Maybe Len has some idea and you don't need to bisect :)
> 
> Thanks to personal coaching of Gabriel i bisected the last few days.
> 
> It looked like this was the cullprit:
> 
> 22aadf8a07067644e101267ed5003043f2ad05bf is first bad commit

Please attach the output from acpidump to 
http://bugzilla.kernel.org/show_bug.cgi?id=7880
We'll likely be able to tell from it if that patch
has any real effect on your system, or if you test
result was from some unrelated event.

Also, please test with CONFIG_X86_ACPI_CPUFREQ=n
to remove the acpi-cpufreq driver (and thus this patch)
from your kernel.  If it still fails, then we know
that this driver (and this patch) are not related
to the failure.

> 2.6.23-rc1-git[1-6] all lockup solid after either direct or
> within a couple of minutes (less than 2) after reboot.
> 
> They all run fine with "acpi=off" as boot argument.

Hmmm, okay, the "big hammer" works.  Please see
if any of these smaller hammers work:

pnpacpi=off
acpi=noirq
notsc

thanks,
-Len
