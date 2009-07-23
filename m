Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZGWOxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZGWOxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbZGWOxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:53:50 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:53281 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075AbZGWOxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:53:50 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.31-rc4: strange change in iomem allocation
Date: Thu, 23 Jul 2009 16:53:48 +0200
User-Agent: KMail/1.9.9
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LFD.2.01.0907221936220.3352@localhost.localdomain> <200907231614.23570.elendil@planet.nl>
In-Reply-To: <200907231614.23570.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907231653.48933.elendil@planet.nl>
X-OriginalArrivalTime: 23 Jul 2009 14:53:49.0476 (UTC) FILETIME=[632B1E40:01CA0BA5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 July 2009, Frans Pop wrote:
> I'm seeing the following change in dmesg between -rc3 and -rc4:
> -system 00:0c: iomem range 0xfec00000-0xfec000ff has been reserved
> +system 00:0c: iomem range 0xfec00000-0xfec000ff could not be reserved
>
> There is nothing in the earlier part of dmesg that would explain this
> change.
>
> The change is also visible in /proc/iomem:
>  fec00000-fec00fff : IOAPIC 0
>    fec00000-fec00fff : reserved
> -    fec00000-fec000ff : pnp 00:0c
>
> I somewhat suspect 857fdc53a0a90c3ba7fcf5b1fb4c7a62ae03cf82:
>     x86/pci: insert ioapic resource before assigning unassigned resources

Reverting that commit did indeed restore the old situation.
