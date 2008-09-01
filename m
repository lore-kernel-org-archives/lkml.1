Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbYIAQvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbYIAQvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYIAQvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:51:24 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:60209 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182AbYIAQvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:51:24 -0400
Message-ID: <48BC1D8E.9050608@lwfinger.net>
Date: Mon, 01 Sep 2008 11:51:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #11355] Regression in 2.6.27-rc2 when cross-building the
 kernel
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>	 <VSpL6AnBTS.A.jvH.vaGsIB@albercik>  <200808242334.05993.rjw@sisk.pl> <1220261720.2982.51.camel@pmac.infradead.org>
In-Reply-To: <1220261720.2982.51.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Sun, 2008-08-24 at 23:34 +0200, Rafael J. Wysocki wrote:
>> On Saturday, 23 of August 2008, Rafael J. Wysocki wrote:
>>> This message has been generated automatically as a part of a report
>>> of recent regressions.
>>>
>>> The following bug entry is on the current list of known regressions
>>> from 2.6.26.  Please verify if it still should be listed and let me know
>>> (either way).
>>>
>>>
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11355
>>> Subject		: Regression in 2.6.27-rc2 when cross-building the kernel
>>> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
>>> Date		: 2008-08-16 2:38 (8 days old)
>>> References	: http://marc.info/?l=linux-kernel&m=121885432118368&w=4
>> As I wrote in the Bugzilla, I'm seeing a related problem.
>>
>> Namely, I build kernels on one box, with 'make O=<target>', then I mount
>> <target> on another one over NFS, 'cd' to it and try to install the kernel
>> modules with 'make modules_install'.  This results in 'HOSTCC firmware/ihex2fw'
>> and 'fatal error: ...: Read-only file system'.  It's readily reproducible.
>>
>> Commenting out line 1130 of Makefile
>> ("$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_modinst")
>> obviously helps, so it looks like Makefile.fwinst needs fixing.
> 
> I don't like this much, but it should do the trick... please confirm.

Yes, the patch fixes the problem. Thanks.

Larry
