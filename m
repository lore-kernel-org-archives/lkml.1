Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbYI0PQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbYI0PQx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 11:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbYI0PQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 11:16:45 -0400
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:48316 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051AbYI0PQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 11:16:44 -0400
From: Frans Pop <elendil@planet.nl>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [Bug #11550] pnp: Huge number of "io resource overlap" messages
Date: Sat, 27 Sep 2008 17:16:37 +0200
User-Agent: KMail/1.9.9
Cc: Rene Herman <rene.herman@keyaccess.nl>, linux-kernel@vger.kernel.org,
       Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, bugme-daemon@bugzilla.kernel.org
References: <200809091250.08620.elendil@planet.nl> <200809201756.25157.bjorn.helgaas@hp.com> <200809261540.31443.bjorn.helgaas@hp.com>
In-Reply-To: <200809261540.31443.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809271716.39119.elendil@planet.nl>
X-OriginalArrivalTime: 27 Sep 2008 15:16:39.0817 (UTC) FILETIME=[0A714F90:01C920B4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 September 2008, Bjorn Helgaas wrote:
> Here's another approach based on section 3.5 of the PCI Firmware spec.
> It says:
>
>   Since not all devices may be configured prior to the operating
>   system handoff, the operating system needs to know whether a
>   specific BAR register has been configured by firmware. The operating
>   system makes the determination by checking the I/O Enable, and
>   Memory Enable bits in the device's command register, and Expansion
>   ROM BAR enable bits. If the enable bit is set, then the corresponding
>   resource register has been configured.
>
> So instead of checking whether the BAR contains zero, the patch below
> checks the I/O, Mem, and ROM BAR enable bits to determine whether a
> BAR is enabled.

That seems to nicely match what the BIOS setting does on my laptop.

> Frans, I'm sorry to trouble you again, but could you test this and
> make sure it takes care of the "resource overlap" messages you saw?

No problem at all. Works correctly (applied on top of current git).
I don't see any unexpected changes in the dmesg output, so:

Tested-by: Frans Pop <elendil@planet.nl>

Cheers,
FJP
