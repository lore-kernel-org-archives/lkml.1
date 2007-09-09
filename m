Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbXIIDt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbXIIDt6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 23:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXIIDtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 23:49:51 -0400
Received: from mail95.megamailservers.com ([216.251.36.95]:58150 "EHLO
	mail95.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752429AbXIIDtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 23:49:50 -0400
X-Authenticated-User: jgeorgas.georgas.ca
Subject: Re: broken ACPI NUMA config option
From: "James C. Georgas" <jgeorgas@georgas.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070908181607.4f36479c.randy.dunlap@oracle.com>
References: <1189291899.13467.20.camel@Tachyon.home>
	 <20070908180904.656f3d03.randy.dunlap@oracle.com>
	 <20070908181607.4f36479c.randy.dunlap@oracle.com>
Content-Type: text/plain
Organization: Georgas Software Solutions
Date: Sat, 08 Sep 2007 23:48:56 -0400
Message-Id: <1189309736.13467.77.camel@Tachyon.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-09 at 18:16 -0700, Randy Dunlap wrote:

> 2.6.23-rc5-git1 builds for me when I follow those steps...
> except for some Section mismatch warnings.
> 

OK, it worked for me also, using torvalds/linux-2.6.git. The behaviour
of the "select" directive in Kconfig appears to have changed since
2.6.22.6. It now turns on ACPI, even when PM is not selected.

This still looks broken to me, because ACPI gets selected by ACPI_NUMA,
and ACPI depends on PM, but PM is not selected. It works out in the end,
as far as the build is concerned, but it still bugs me.

Does anyone object to the idea of a selected item automatically
selecting its own dependencies?

For example, you would only need to specify one "select" directive in
X86_64_ACPI_NUMA, (i.e. to turn on ACPI_NUMA). The configuration system
would then recursively walk up ACPI_NUMA's dependency hierarchy, turning
on what it needed.

James
	/\V

