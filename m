Return-Path: <linux-kernel-owner+w=401wt.eu-S1760257AbYFXPW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257AbYFXPW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 11:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbYFXPWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 11:22:49 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:2539 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbYFXPWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 11:22:48 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [PATCH] ACPI: don't walk tables if ACPI was disabled
Date: Tue, 24 Jun 2008 09:22:21 -0600
User-Agent: KMail/1.9.9
Cc: "Ingo Molnar" <mingo@elte.hu>, "Len Brown" <lenb@kernel.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       "Zhao Yakui" <yakui.zhao@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
References: <20080620135639.GA5073@damson.getinternet.no> <20080624114139.GC21890@elte.hu> <19f34abd0806240452w2561040uc2b1b1d35562db71@mail.gmail.com>
In-Reply-To: <19f34abd0806240452w2561040uc2b1b1d35562db71@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806240922.22300.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2008 5:52:55 am Vegard Nossum wrote:
> On 6/24/08, Ingo Molnar <mingo@elte.hu> wrote:
> > i havent seen the warning reappear with your fix after thousands of
> > bootups - so i guess we can consider it fixed.
> >
> > Len, please consider the patch below. (it's in tip/out-of-tree)
>
> No, please don't :-)
>
> It fixes your particular case (the acpi_rtc_init() hunk of the patch),
> but the acpi_walk_namespace() part should be changed to a WARN(). But
> that is likely to cause a lot of "spurious" reports, so the other acpi
> drivers should be fixed as well.
>
> I was waiting for Len to reply, but maybe I can submit the proper fix too.

I haven't looked into the acpi_walk_namespace() question.

But I did look at the acpi_rtc_init() stuff, and I have to say it
looks like a really round-about way to accomplish this.  I'd rather
just fold in the FADT accesses directly into cmos_do_probe() and
dispense with the stuff in drivers/acpi/glue.c.  I'm working on a
couple patches along this line, but it will take me a few days to
finish up.

Bjorn
