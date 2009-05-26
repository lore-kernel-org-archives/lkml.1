Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbZEZQ7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbZEZQ7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbZEZQ71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:59:27 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:33858 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbZEZQ71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:59:27 -0400
Message-ID: <4A1C1FD5.2010106@s5r6.in-berlin.de>
Date: Tue, 26 May 2009 18:59:01 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Simon_K=F6nig?= <simjoko@gmail.com>
CC: linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       debiandev@gmail.com
Subject: Re: Unable to compile 2.6.30-rc7 on RHEL 4 - GCC 3.4.6
References: <f24d23310905250956u231fcd90u54d75894b9b91b9a@mail.gmail.com> <gvf1ti$77e$1@ger.gmane.org>
In-Reply-To: <gvf1ti$77e$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon König wrote:
> On 05/25/09 18:56, debian developer wrote:
>> Hi all,
>> 
>> I am getting this error when trying to compile the latest rc:
>> 
>> /in/inndesk171/linux-2.6.28/arch/x86/Makefile:82: stack protector
>> enabled but no compiler support
> 
> Hello!
> 
> As the message states, your compiler does not support this kernel feature.
> You may want to disable CC_STACKPROTECTOR or use a gcc >= 4.2.

Isn't this only a notification (warning if you will), not an error?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=arch/x86/Kconfig;h=a6efe0a2e9ae613a81bedec5e4772698d16541cc;hb=HEAD#l1410
"This feature requires gcc version 4.2 or above, or a distribution gcc
with the feature backported. Older versions are automatically detected
and for those versions, this configuration option is ignored. (and a
warning is printed during bootup)"

Actual error messages start at:

>>   CC      init/main.o
>> /in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h: In
>> function `start_kernel':
>> /in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1590:
>> warning: asm operand 1 probably doesn't match constraints
[...]
>> /in/inndesk171/linux-2.6.28/arch/x86/include/asm/paravirt.h:1590:
>> error: impossible constraint in `asm'
[...]

Hard to tell from here where the cause is. Cc'd Jeremy as somebody who
knows paravirt.h.  Thread start:  http://lkml.org/lkml/2009/5/25/303
-- 
Stefan Richter
-=====-==--= -=-= ==-=-
http://arcgraph.de/sr/
