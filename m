Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbYDUUsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbYDUUsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYDUUrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:47:52 -0400
Received: from ns1.suse.de ([195.135.220.2]:35995 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbYDUUrv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:47:51 -0400
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: PCI MSI breaks when booting with nosmp
Date: Mon, 21 Apr 2008 22:48:02 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Tejun Heo <htejun@gmail.com>,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>
References: <200804172140.02311.jdelvare@suse.de> <200804212220.20577.jdelvare@suse.de> <20080421204651.GB21028@one.firstfloor.org>
In-Reply-To: <20080421204651.GB21028@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804212248.02986.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Le lundi 21 avril 2008, Andi Kleen a écrit :
> > In my case, booting with noapic works fine, so I don't think that the problem
> > is related to APIC being disabled.
> 
> noapic is not the same as no ioapic. maxcpus=0 just disables the IO-APIC
> but not the local APIC.

>From init/main.c:

static int __init maxcpus(char *str)
{
	get_option(&str, &setup_max_cpus);
	if (setup_max_cpus == 0)
		disable_ioapic_setup();

	return 0;
}
early_param("maxcpus", maxcpus);

>From arch/x86/kernel/io_apic_32.c:

static int __init parse_noapic(char *arg)
{
	/* disable IO-APIC */
	disable_ioapic_setup();
	return 0;
}
early_param("noapic", parse_noapic);

Both call disable_ioapic_setup(), so how can they not be the same?

-- 
Jean Delvare
Suse L3
