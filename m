Return-Path: <linux-kernel-owner+w=401wt.eu-S1751521AbXJUVER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbXJUVER (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 17:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbXJUVEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 17:04:08 -0400
Received: from hpsmtp-eml12.KPNXCHANGE.COM ([213.75.38.112]:37692 "EHLO
	hpsmtp-eml12.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757AbXJUVEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 17:04:07 -0400
From: Frans Pop <elendil@planet.nl>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Why are ipmi modules being loaded?
Date: Sun, 21 Oct 2007 23:04:02 +0200
User-Agent: KMail/1.9.7
References: <200710211534.11817.elendil@planet.nl> <20071021200936.GG32207@redhat.com>
In-Reply-To: <20071021200936.GG32207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710212304.02990.elendil@planet.nl>
X-OriginalArrivalTime: 21 Oct 2007 21:04:03.0271 (UTC) FILETIME=[E8D57D70:01C81425]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 October 2007, Dave Jones wrote:
> On Sun, Oct 21, 2007 at 03:34:11PM +0200, Frans Pop wrote:
>  > AFAICT from modules.pcimap, ipmi_si should only be loaded for PCI ID
>  > [103c:121a] (which I don't have), or for devices with class c0700
>  > (which I also don't have).
>
> Hmm, is lspci truncating the class code?
>
>  > 01:00.4 Serial bus controller [0c07]: Intel Corporation 82573E KCS
>  > (Active Management) [8086:108e] (rev 03)

Actually, these three look to be related (see also link below):
01:00.0 Ethernet controller: Intel Corporation 82573E Gigabit Ethernet 
Controller (Copper) (rev 03)
01:00.3 Serial controller: Intel Corporation Active Management Technology - 
SOL (rev 03)
01:00.4 Serial bus controller [0c07]: Intel Corporation 82573E KCS (Active 
Management) (rev 03)

I did check the class files in /sys. For these devices those have:
$ cat /sys/bus/pci/devices/0000\:01\:00.0/class
0x020000
$ cat /sys/bus/pci/devices/0000\:01\:00.3/class
0x070002
$ cat /sys/bus/pci/devices/0000\:01\:00.4/class
0x0c0701

The last is close, but still does not match the 0x0c0700 in modules.pcimap. 
Is there some fuzzy matching going on there?

> Because this smells like an IPMI-ish device.

Hmm. Yes, guess it is -ish. It's documented in:
http://download.intel.com/design/motherbd/cz/D1406801US.pdf (section 1.11.4)

Looks like something that is only useful for remote management though and 
not for on-system management.

Anyway, I've blacklisted the modules for now, but still feel that should not 
be necessary and there's an incorrect match happening.

Thanks for the reply Dave.
