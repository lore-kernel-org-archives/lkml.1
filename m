Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbYFYCtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbYFYCtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 22:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYFYCtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 22:49:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:59541 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbYFYCta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 22:49:30 -0400
Date: Tue, 24 Jun 2008 19:49:15 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Len Brown <lenb@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Zhao Yakui <yakui.zhao@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] ACPI: add standard linux WARN() output to ACPI warnings
Message-ID: <20080624194915.11d6aee9@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0806242231120.3014@localhost.localdomain>
References: <20080620095247.GA24557@elte.hu>
	<20080620135639.GA5073@damson.getinternet.no>
	<20080620142224.GF8135@elte.hu>
	<alpine.LFD.1.10.0806242231120.3014@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008 22:34:25 -0400 (EDT)
Len Brown <lenb@kernel.org> wrote:

> From: Len Brown <len.brown@intel.com>
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
> > i have hit this warning for the first time in January 2008:
> ...
> > that's why WARN_ON()s are so important - there's no way my
> > automated tools (or even i, when taking a casual look at the logs)
> > could have picked up that new ACPI Exception - if each subsystem
> > has different warnings (which change frequently) then it's sheer
> > impossible to automate the answer to the "does that log show any
> > anomaly" question. 
> 
> Maybe something like this would help?
> (totally untested)
> 
> -Len
> 
> diff --git a/drivers/acpi/utilities/utmisc.c
> b/drivers/acpi/utilities/utmisc.c index 1f057b7..d53e82c 100644
> --- a/drivers/acpi/utilities/utmisc.c
> +++ b/drivers/acpi/utilities/utmisc.c
> @@ -1028,6 +1028,7 @@ acpi_ut_error(char *module_name, u32
> line_number, char *format, ...) {
>  	va_list args;
>  
> +	warn_on_slowpath(module_name, line_number);
>  	acpi_os_printf("ACPI Error (%s-%04d): ", module_name,
> line_number); 



Please do not use warn_on_slowpath() directly!
Please use WARN_ON() or WARN(). The later has printk semantics so this
could turn into

WARN(1, "ACPI Error (%s-%0d): \n", module_name, line_number);


and kerneloops.org and various other tools will pick up the printk like
arguments as part of the warning message.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
