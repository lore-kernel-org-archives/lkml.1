Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbXIIFCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbXIIFCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 01:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbXIIFCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 01:02:07 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:43524 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbXIIFCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 01:02:06 -0400
Date: Sat, 8 Sep 2007 22:00:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "James C. Georgas" <jgeorgas@georgas.ca>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: broken ACPI NUMA config option
Message-Id: <20070908220043.8830512d.randy.dunlap@oracle.com>
In-Reply-To: <1189309736.13467.77.camel@Tachyon.home>
References: <1189291899.13467.20.camel@Tachyon.home>
	<20070908180904.656f3d03.randy.dunlap@oracle.com>
	<20070908181607.4f36479c.randy.dunlap@oracle.com>
	<1189309736.13467.77.camel@Tachyon.home>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 Sep 2007 23:48:56 -0400 James C. Georgas wrote:

> On Sat, 2007-08-09 at 18:16 -0700, Randy Dunlap wrote:
> 
> > 2.6.23-rc5-git1 builds for me when I follow those steps...
> > except for some Section mismatch warnings.
> > 
> 
> OK, it worked for me also, using torvalds/linux-2.6.git. The behaviour
> of the "select" directive in Kconfig appears to have changed since
> 2.6.22.6. It now turns on ACPI, even when PM is not selected.
> 
> This still looks broken to me, because ACPI gets selected by ACPI_NUMA,
> and ACPI depends on PM, but PM is not selected. It works out in the end,
> as far as the build is concerned, but it still bugs me.
> 
> Does anyone object to the idea of a selected item automatically
> selecting its own dependencies?
> 
> For example, you would only need to specify one "select" directive in
> X86_64_ACPI_NUMA, (i.e. to turn on ACPI_NUMA). The configuration system
> would then recursively walk up ACPI_NUMA's dependency hierarchy, turning
> on what it needed.

That is highly desirable IMO.  Not having that is one of the things
that makes using 'select' "evil."

Have you looked at the code and given any thought to implementing this?

Thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
