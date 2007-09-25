Return-Path: <linux-kernel-owner+w=401wt.eu-S1760403AbXIYQbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760403AbXIYQbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbXIYQbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:31:44 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:39754 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752891AbXIYQbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:31:43 -0400
Message-ID: <46F937E3.2090807@suse.de>
Date: Tue, 25 Sep 2007 20:31:31 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Alexey Starikovskiy <aystarik@gmail.com>,
       Damien Wyart <damien.wyart@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
References: <20070925065109.GA3080@localhost.localdomain>	 <20070925003340.5d6dd7f4.akpm@linux-foundation.org>	 <46F8C880.1010006@suse.de>	 <64bb37e0709250208gcbdeb6do6026e138e746bde2@mail.gmail.com>	 <46F8F033.2040402@gmail.com> <64bb37e0709250930m555a9586j35a1d579ea5a3713@mail.gmail.com>
In-Reply-To: <64bb37e0709250930m555a9586j35a1d579ea5a3713@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
> On 9/25/07, Alexey Starikovskiy <aystarik@gmail.com> wrote:
>> Torsten Kaiser wrote:
>>> No, I do not have CONFIG_ACPI_SLEEP set,
>>> because I do not have CONFIG_PM_SLEEP set,
>>> because I do not want SUSPEND and/or HIBERNATION.
>> This is not the reason. SUSPEND is controlled with CONFIG_SUSPEND and
>> HIBERNATION is controlled with CONFIG_HIBERNATION.
>> But if you want S5 ACPI sleep state you might want to enable ACPI_SLEEP...
> 
> What I meant with SUSPEND and/or HIBERNATION was CONFIG_SUSPEND /
> CONFIG_HIBERNATION.
> 
> And the relations where from Kconfig:
> from drivers/acpi/Kconfig:
> config ACPI_SLEEP
>         bool
>         depends on PM_SLEEP
>         default y
> 
> -> no PM_SLEEP means no ACPI_SLEEP
> 
> from kernel/power/Kconfig:
> config PM_SLEEP
>         bool
>         depends on SUSPEND || HIBERNATION
>         default y
> 
> -> No SUSPEND and/or HIBERNATION means no PM_SLEEP
> 
> And if I select SUSPEND and/or HIBERNATION I will not only build this
> feature into the kernel, but also HOTPLUG_CPU and I want to avoid
> that.
> 
> It's exactly as Linus said in his mail: Not everybody wants SUSPEND...
> 
> I should have formulated that better in my mail, but that was what I
> wanted to say.
> 
> 
> Back to debugging this:
> http://marc.info/?l=linux-acpi&m=119052970904643&w=4
> fails to apply against 2.6.23-rc7-mm1, but moving that function by
> hand was not to difficult. ;)
> (With only the second patch I got a link error...)
> 
> http://marc.info/?l=linux-acpi&m=119073173625910&w=4
> applied, and a test showed that my system now powers off again.
> 
> Torsten
Understood, patches are available, please test.

Regards,
Alex.
