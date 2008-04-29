Return-Path: <linux-kernel-owner+w=401wt.eu-S1760249AbYD2UoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249AbYD2UoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYD2UoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:44:15 -0400
Received: from outbound-mail-134.bluehost.com ([67.222.39.24]:55259 "HELO
	outbound-mail-134.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751282AbYD2UoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:44:14 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] x86: fix section mismatch in pci_scan_bus
Date: Tue, 29 Apr 2008 13:44:06 -0700
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
References: <20080429203848.GA13741@uranus.ravnborg.org>
In-Reply-To: <20080429203848.GA13741@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804291344.06657.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2008 1:38 pm Sam Ravnborg wrote:
> Fix following section mismatch warning:
> WARNING: vmlinux.o(.text+0x275616): Section mismatch in reference from the
> function pci_scan_bus() to the function
> .devinit.text:pci_scan_bus_parented()
>
> The warning was seen with a CONFIG_DEBUG_SECTION_MISMATCH=y build.
> The inline function pci_scan_bus refer to functions annotated
> __devinit - so annotate it __devinit too.
> This revealed a few x86 specific functions that were only
> used from __init or __devinit context.
> So annotate these __devinit and the warning was killed.
>
> The added include in pci.h was not strictly required but
> added to avoid being dependent on indirect includes.
>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Applied, thanks Sam.

Jesse
