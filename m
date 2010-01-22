Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578Ab0AVTPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab0AVTPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 14:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669Ab0AVTPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 14:15:38 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:57768 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab0AVTPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 14:15:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:in-reply-to
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=CQjSZEYYqzPd81QKUvilgshTbHnRKLmX8Z+5DZNkF9/qFDqutdUAVXxFRPTY444/K3
         1of5qH2mMcgQhW3BdOV2sce4wAjCqJVNCJ4gfayY91zEyVul+rwokPnXO5WGG8vqu43f
         COrjizMzGi7oJtuez3zGApK61V7DnolvsZ5po=
Date: Fri, 22 Jan 2010 22:45:15 +0330
From: Ali Gholami Rudi <aligrudi@gmail.com>
To: astarikovskiy@suse.de, ali@rudi.ir
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: kacpi_notify_wq and kacpid_wq use a lot of cpu
Message-ID: <4b59f943.YZS7qMjt5K3V8Wa3UVeL40l8@lilem.mirepesht>
References: <4b59efdb.E0ClbTr8sKopLDl5JyKeEOdy@lilem.mirepesht>
 <4B59F40E.2090102@suse.de>
In-Reply-To: <4B59F40E.2090102@suse.de>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Starikovskiy <astarikovskiy@suse.de> wrote:
> > Sometimes kacpi_notify_wq and kacpid_wq workqueues use a lot of cpu.
> > 
> > I'm using yesterday's tip.  At times kacpi_notify_wq uses 30-50% of
> > my cpu and kacpid_wq uses 3-5%:
> > 
> > # uptime
> >  12:49:54 up  4:16,  1 user,  load average: 0.52, 0.55, 0.40
> > # ps -e | grep kacpi
> >   189 ?        00:00:52 kacpid
> >   190 ?        00:10:26 kacpi_notify
> >   191 ?        00:00:00 kacpi_hotplug
> > 
> > This sometimes happens after a few hours of uptime; so this is
> > very hard to bisect (by the way, I think the same thing causes
> > the fans to work fullspeed sometimes when I reboot the machine).
> > I tried this patch to find out which of the callers of
> > acpi_os_execute() is the culprit:
> > 
> > Is there something I can do to trace the problem? dmesg and lspci
> > are attached.
>
> Please open new bug at bugzilla.kernel.org, for ACPI. 

http://bugzilla.kernel.org/show_bug.cgi?id=15106

> It would help if you provide name of your machine (make?)

This is a hp-compaq 610 laptop.

> and acpidump output.

Attached to the bugzilla report.

> Do you know the kernel, there this problem did not occur (is it a regression)?

The oldest kernel I tried on this machine was something after 2.6.32
and it had the same problem.

Thanks,
Ali

