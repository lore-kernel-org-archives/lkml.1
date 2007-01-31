Return-Path: <linux-kernel-owner+w=401wt.eu-S932106AbXAaBUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbXAaBUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932118AbXAaBUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:20:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:46842 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106AbXAaBUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:20:51 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Joe Harvell <jharvell+lists.linux-kernel@dogpad.net>
Subject: Re: ACPI C and P states on Conroe
Date: Tue, 30 Jan 2007 20:17:47 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, cpufreq@lists.linux.org.uk
References: <45BF81CF.2060801@dogpad.net>
In-Reply-To: <45BF81CF.2060801@dogpad.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701302017.47599.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 January 2007 12:35, Joe Harvell wrote:
> I am trying to enable all the power saving features I can on my Conroe
> E6600.  After much searching on the web, I am a little confused about
> the Linux kernel support for ACPI on the Conroe.
> 
> Here is my setup:
> Intel Core2 Duo E6600
> Asus P5-B Deluxe board (Intel P965).
> I am running a Gentoo kernel based on 2.6.19.4.
> 
> I have managed to enable EIST using cpufreq with the speedstep-centrino
> driver.  But my understanding from browsing the ACPI spec is that this
> is still within C0, i.e. not much power savings.

Right, P-states are effective only when code is executing,
and on this processor (with C1E) will have no effect on idle power.

> Here are my questions:
> 
> 1) For P states, which cpufreq driver should I be using?  I've heard
> speedstep-centrino is deprecated (but only some aspects of it) that are
> being moved into acpi-cpufreq.  But I can't get acpi-cpufreq to load in
> my kernel version.

In 2.6.19 I believe that speedstep-centrino is the one to use.
The transition to acpi-cpufreq happens in 2.6.20.

> Also, I would have thought speedstep-ich would be 
> the driver, just based on the name.

Don't use speedstep-ich.

> How do I know (other than trying 
> all modules to see which one loads) which one I should be using?
> 2) What kind of support for C1-C3 does the Conroe have?  The ACPI spec
> says C2 and C3 require chipset support on the motherboard.  Does P965
> have that.  Does it matter between boards (e.g. P5B)?

I believe that Conroe currently supports just C1 --
this is true for the ones I have.

Internally it is an "Enhanced C1" called C1E where the voltage is reduced
in C1-- but this is transparent to software, which thinks it is just C1.

You can observe this in
/proc/acpi/processor/*/power

> 3) What versions of the kernel support C1-C3 states?  What kernel
> options are germane to this?  What libraries/tools are involved?

C1-C3 have been supported for a long time.
2.6.20 adds a few tweaks to use a more efficient implementation,
but you'll not notice a difference on today's desktop processor.

cheers,
-Len
