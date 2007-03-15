Return-Path: <linux-kernel-owner+w=401wt.eu-S933798AbXCOUX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798AbXCOUX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933812AbXCOUX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:23:27 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:1441 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933798AbXCOUX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:23:26 -0400
Date: Thu, 15 Mar 2007 21:20:43 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Nicolas Boichat <nicolas@boichat.ch>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, bytes@linuxgazette.net,
       linux-kernel@vger.kernel.org, debian-user@lists.debian.org
Subject: Re: [lm-sensors] Intel Core Duo/Solo Temperature Monitoring Working
 On Intel DG965 Motherboard
Message-Id: <20070315212043.196db045.khali@linux-fr.org>
In-Reply-To: <45F92D99.1020007@boichat.ch>
References: <Pine.LNX.4.64.0703100707320.3807@p34.internal.lan>
	<45F92D99.1020007@boichat.ch>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On Thu, 15 Mar 2007 19:27:21 +0800, Nicolas Boichat wrote:
> I ported this patch to the latest git, I hope this can help to get it
> merged.
> 
> I'm just wondering if it is right to export the functions msr_read and
> msr_write from arch/i386/kernel/msr.c, or if it would be better to put
> these functions in arch/i386/lib/msr-on-cpu.c with rdmsr_on_cpu and
> wrmsr_on_cpu.
> 
> Note the difference between msr_read/msr_write and
> rdmsr_on_cpu/wrmsr_on_cpu is that msr_read/msr_write use "safe" rdmsr
> /wrmsr functions (i.e. test return value), while
> rdmsr_on_cpu/wrmsr_on_cpu does not. Coretemp needs the return value to
> work properly.

I reviewed Rudolf Marek's patches a few days ago and my first comment
was along these lines:
http://lists.lm-sensors.org/pipermail/lm-sensors/2007-March/019169.html

I do indeed believe that the functions in lib/msr-on-cpu.c should be
improved to be suitable for our needs. Others are likely to need the
same feature. Library functions should really return the errors, and
leave it up to the caller to decide whether to ignore them or not,
rather than hiding them.

Could you possibly propose a separate patch fixing lib/msr-on-cpu.c (on
both i386 and x86_64) to reliably report the errors? I guess it's a
simple matter of changing the prototypes of the functions? If we can
get this upstream, this would make the integration of the coretemp
driver easier and faster.

Thanks,
-- 
Jean Delvare
