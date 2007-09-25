Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbXIYPk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbXIYPk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbXIYPku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:40:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54923 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755405AbXIYPkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:40:49 -0400
Date: Tue, 25 Sep 2007 08:40:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Damien Wyart <damien.wyart@free.fr>, LKML <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Frans Pop <elendil@planet.nl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
In-Reply-To: <20070925003340.5d6dd7f4.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0709250830420.3579@woody.linux-foundation.org>
References: <20070925065109.GA3080@localhost.localdomain>
 <20070925003340.5d6dd7f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 Sep 2007 08:51:09 +0200 Damien Wyart <damien.wyart@free.fr> wrote:
> 
> Hello,
> 
> After testing rc8, I noticed that I couldn't power off the computer
> directly, it only got halted and I had to press the power button
> manually. Just before displaying "System halted", the following message
> is displayed:
> 
>   ACPI : PCI interrupt for device 0000:02:08.0 disabled
> 
> I had to first revert 5a50fe709d527f31169263e36601dd83446d5744 then
> f216cc3748a3a22c2b99390fddcdafa0583791a2 (handling of Sx states) to
> recover previous behaviour.

Hmm. Those things *do* seem to be suspicious.

For example, those commits seem to move code that used to be inside 
CONFIG_PM (which pretty much *everybody* has) to be inside 
CONFIG_ACPI_SLEEP (which is a totally different thing, and depends on 
whether the user asked for suspend support or not!

Damien - does it work if you ask for SUSPEND or HIBERNATION support?

Len - why are you guys moving stuff into CONFIG_PM_SLEEP? I know you seem 
to think that absolutely *everybody* should always support suspend and 
hibernation, but the fact is, not everybody does. And it's a totally 
separate thing for normal ACPI CPU runstate support that people have used 
to manage a *running* CPU (and shutting it down).

		Linus
