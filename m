Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbXE3PVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbXE3PVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbXE3PVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:21:17 -0400
Received: from outbound-mail-76.bluehost.com ([69.89.22.25]:58234 "HELO
	outbound-mail-76.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752134AbXE3PVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:21:16 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH -mm] 0/2: PCI MMCONFIG-related updates
Date: Wed, 30 May 2007 08:21:11 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <465CF712.2010604@shaw.ca>
In-Reply-To: <465CF712.2010604@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705300821.11555.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 29, 2007 9:01:22 Robert Hancock wrote:
> These two patches implement some changes in behavior related to PCI
> MMCONFIG configuration space access. One changes the way in which we
> validate the MCFG table provided by the BIOS by checking it against
> ACPI motherboard resources instead of the E820 table. The BIOS is not
> required to reserve this area in the E820 table, so checking that
> results in MMCONFIG being unnecessarily disabled on some machines.
>
> Some Intel chipsets where MMCONFIG was being disabled previously
> (but won't be with the first patch) had problems, not due to the
> MCFG table being broken, but because the access was hosed by the way
> in which we do PCI BAR sizing. The second patch fixes this problem.
>
> This is requested for inclusion in the -mm tree for testing.

Robert, should we also pull in the 915 and 965 chipset specific register 
poking code?  It might be a good sanity check against ACPI (i.e. if ACPI and 
the actual register window disagree, we can assume the BIOS is broken and 
MCFG is not safe to use).  If so, I'll update and repost them against your 
patchset.

Thanks,
Jesse
