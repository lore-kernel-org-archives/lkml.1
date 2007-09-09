Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbXIIReP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbXIIReP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 13:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbXIIReA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 13:34:00 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:22058 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbXIIRd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 13:33:59 -0400
Message-ID: <46E42E19.4040701@oracle.com>
Date: Sun, 09 Sep 2007 10:32:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: "James C. Georgas" <jgeorgas@georgas.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: broken ACPI NUMA config option
References: <1189291899.13467.20.camel@Tachyon.home>	 <20070908180904.656f3d03.randy.dunlap@oracle.com>	 <20070908181607.4f36479c.randy.dunlap@oracle.com>	 <1189309736.13467.77.camel@Tachyon.home>	 <20070908220043.8830512d.randy.dunlap@oracle.com> <1189345287.7365.23.camel@Tachyon.home>
In-Reply-To: <1189345287.7365.23.camel@Tachyon.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James C. Georgas wrote:
> On Sat, 2007-08-09 at 22:00 -0700, Randy Dunlap wrote:
>>> For example, you would only need to specify one "select" directive in
>>> X86_64_ACPI_NUMA, (i.e. to turn on ACPI_NUMA). The configuration system
>>> would then recursively walk up ACPI_NUMA's dependency hierarchy, turning
>>> on what it needed.
>> That is highly desirable IMO.  Not having that is one of the things
>> that makes using 'select' "evil."
>>
>> Have you looked at the code and given any thought to implementing this?
>>
> 
> I'd like to take a run at it. The only issue I foresee is what to do
> about multiple OR dependencies. There are some kconfig options that
> depend on at least one of a set of specified dependencies. For example,
> is ARCH_SPARSEMEM_ENABLE selectable if only one of NUMA || EXPERIMENTAL
> is selected? So do we abort, select one, or select all dependencies?

It's a logical OR, meaning one or more of them is enabled.

I expect that there are some places that enabling all dependencies
would very much be the wrong thing to do, and choosing only one is
just a wild guess, so it looks like you would have to abort, with a
helpful message.

> Maybe I'm misunderstanding the usage of || here though. I'm assuming
> inclusive OR.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
