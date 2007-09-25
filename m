Return-Path: <linux-kernel-owner+w=401wt.eu-S1760706AbXIYQaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706AbXIYQaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757379AbXIYQaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:30:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:51475 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbXIYQaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:30:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R58hRDor6Cyc3wXWFaY1tht4bBO5gnbv8e0l0la+UTXaIfaEoIg9/Rw9/Mdfypm1qz6KhnAdB4P5D0XWg1r1vsSsVDoAcNSE/khpjv//QIWvY6SYPhIQ4U14SJRvic0B5IpiIjGIfL5mqv4x+tMe8RdMooDRWikMFwTeoABtRLA=
Message-ID: <64bb37e0709250930m555a9586j35a1d579ea5a3713@mail.gmail.com>
Date: Tue, 25 Sep 2007 18:30:00 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Alexey Starikovskiy" <aystarik@gmail.com>
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
Cc: "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Damien Wyart" <damien.wyart@free.fr>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Len Brown" <len.brown@intel.com>,
       "Frans Pop" <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
In-Reply-To: <46F8F033.2040402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070925065109.GA3080@localhost.localdomain>
	 <20070925003340.5d6dd7f4.akpm@linux-foundation.org>
	 <46F8C880.1010006@suse.de>
	 <64bb37e0709250208gcbdeb6do6026e138e746bde2@mail.gmail.com>
	 <46F8F033.2040402@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/25/07, Alexey Starikovskiy <aystarik@gmail.com> wrote:
> Torsten Kaiser wrote:
> > No, I do not have CONFIG_ACPI_SLEEP set,
> > because I do not have CONFIG_PM_SLEEP set,
> > because I do not want SUSPEND and/or HIBERNATION.
> This is not the reason. SUSPEND is controlled with CONFIG_SUSPEND and
> HIBERNATION is controlled with CONFIG_HIBERNATION.
> But if you want S5 ACPI sleep state you might want to enable ACPI_SLEEP...

What I meant with SUSPEND and/or HIBERNATION was CONFIG_SUSPEND /
CONFIG_HIBERNATION.

And the relations where from Kconfig:
from drivers/acpi/Kconfig:
config ACPI_SLEEP
        bool
        depends on PM_SLEEP
        default y

-> no PM_SLEEP means no ACPI_SLEEP

from kernel/power/Kconfig:
config PM_SLEEP
        bool
        depends on SUSPEND || HIBERNATION
        default y

-> No SUSPEND and/or HIBERNATION means no PM_SLEEP

And if I select SUSPEND and/or HIBERNATION I will not only build this
feature into the kernel, but also HOTPLUG_CPU and I want to avoid
that.

It's exactly as Linus said in his mail: Not everybody wants SUSPEND...

I should have formulated that better in my mail, but that was what I
wanted to say.


Back to debugging this:
http://marc.info/?l=linux-acpi&m=119052970904643&w=4
fails to apply against 2.6.23-rc7-mm1, but moving that function by
hand was not to difficult. ;)
(With only the second patch I got a link error...)

http://marc.info/?l=linux-acpi&m=119073173625910&w=4
applied, and a test showed that my system now powers off again.

Torsten
