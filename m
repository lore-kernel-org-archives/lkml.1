Return-Path: <linux-kernel-owner+w=401wt.eu-S1761396AbZD3JHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761396AbZD3JHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 05:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbZD3JHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 05:07:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbZD3JHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 05:07:07 -0400
From: Thomas Renninger <trenn@suse.de>
To: djwong@us.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot even when ignore_ppc=0
Date: Thu, 30 Apr 2009 11:07:45 +0200
User-Agent: KMail/1.9.10
Cc: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <20090415225348.GW8311@plum> <200904291519.29683.trenn@suse.de> <20090429214312.GX7917@plum>
In-Reply-To: <20090429214312.GX7917@plum>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904301107.45753.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 April 2009 11:43:12 pm Darrick J. Wong wrote:
> On Wed, Apr 29, 2009 at 03:19:28PM +0200, Thomas Renninger wrote:
> > Ingo, did you do a BIOS update in between?
> > The DSDT and SSDTs you added do not contain a _PPC function.
> > These ACPI tables definitely do not suffer from an initial _PPC
> > evaluation.
>
> P-state tables are probably loaded from separate SSDT tables "CPU0IST" and
> "CPU1IST".  You can download 'em with something like this:
>
> # dmesg | grep IST
> ACPI: SSDT BFD30566, 01FB (r1  PmRef    CPU0IST   3000 INTL 20030224)
>            ^addr     ^length
>
> # acpidump --addr 0xBFD30566 --length 0x1FB > cpu0ist
> # iasl -d cpu0ist
>
> Then paste cpu0ist.dsl somewhere.

Oops forgot about the tables loaded at runtime, I take back the definitely :)
Ingo, can you also do:
acpidump --addr 0x7F6E609E --length 0x1ED >cpu0ist
acpidump --addr 0x7F6E628B --length 0x94 >cpu1ist
acpidump --addr 0x7F6E5DE1 --length 0x238 >cpu0cst
acpidump --addr 0x7F6E6019 --length 0x85 >cpu1cst

Then we should finally have all ACPI bits of such an affected system together.
The addresses and table lengths should work for your T60 and can be found in 
the SSDT2:
Name (SSDT, Package (0x0C)
        {
            "CPU0IST ",
            0x7F6E609E,
            0x000001ED,
            "CPU1IST ",
            0x7F6E628B,
            0x00000094,
            "CPU0CST ",
            0x7F6E5DE1,
            0x00000238,
            "CPU1CST ",
            0x7F6E6019,
            0x00000085
        })

Thanks,

     Thomas
