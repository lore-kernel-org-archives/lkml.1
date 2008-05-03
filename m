Return-Path: <linux-kernel-owner+w=401wt.eu-S1762706AbYECKbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762706AbYECKbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 06:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbYECKbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 06:31:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50106 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755198AbYECKbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 06:31:36 -0400
Subject: Re: [PATCH 0/13] Updated V4  - Regulator Framework
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       broonie@opensource.wolfsonmicro.com
In-Reply-To: <20080502165248.dba934e9.akpm@linux-foundation.org>
References: <1209742841.12502.40.camel@odin>
	 <20080502165248.dba934e9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 03 May 2008 11:31:32 +0100
Message-Id: <1209810693.12502.97.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 16:52 -0700, Andrew Morton wrote:
> On Fri, 02 May 2008 16:40:41 +0100
> Liam Girdwood <lg@opensource.wolfsonmicro.com> wrote:
> 
> > This is an updated version of the kernel voltage & current regulator
> > framework based on comments received from version 3 of the patch series.
> > 
> > The regulator framework is designed to provide a standard kernel
> > interface to control voltage and current regulators on SoC based
> > systems.
> > 
> > The intention is to allow systems to dynamically control regulator power
> > output in order to save power and prolong battery life. This applies to
> > both voltage regulators (where voltage output is controllable) and
> > current sinks (where current limit is controllable).
> > 
> 
> oh gee.
> 
> I (and others) reviewed and commented on all this code last month.  Now
> here it is again and, although I'm sure it is delightful code, nobody wants
> to have to read it all again ;)
> 
> The one-month gap between v3 and v4 is unfortunate.  It means that everyone
> has forgotten everything.
> 

Sorry about this. It really couldn't be helped as I've been on the road
a lot lately. I was even in the audience for your talk at CELF ;)

> 
> Was all the review feedback satisfactorily handled to the reviewers'
> satisfaction?
> 

Summary of changes re V3 comments :-

 o Added lots of documentation.
 o Added ABI documentation.
 o Changed debug option Kconfig style.
 o Regulator no longer a class device.
 o sysfs naming changes, ie. now uses microvolts and microamps.
 o sysfs entries only export one value.
 o get_current() macro undef removed.
 o set_voltage(), set_current_limit() now take a lower and upper
acceptable value.
 o Fixed a locking issue.
 o Made 'compiled out' interface all static inline instead of macros.
 o Removed dynamic voltage control where the voltage would be
dynamically managed to be the lowest for all consumers (no known users
of this code atm - although spoke with someone at CELF who was
interested in this feature for the future).
 o Checkpatch fixes.
 o Removed comments describing some functions from the headers - now all
such comments are in the c files.

> Is there any new material in here which would require a re-review?

Yes. Other additions :-

 o Test harness added to aid developers with testing regulator drivers
(virtual.c - patch 07/13).
 o Support for fixed output regulators. i.e. regulators that cannot be
controlled by software but coexist on systems with software controllable
regulators (fixed.h, fixed.c - patches 04/13 and 06/13)
 o Bulk operations for consumers that may have multiple regulator
supplies (consumer.h, core.c - patches 01/13 and 05/13)
 o Changed core file and header names to be more meaningful. i.e
reg-core.c -> core.c, regulator/regulator.h -> regulator/consumer.h,
etc.

Lastly, I've forgotten the MAINTAINERS patch but this can be added
later.

Liam

