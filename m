Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab0BQV3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:29:12 -0500
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:49178 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754209Ab0BQV3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:29:10 -0500
From: Frans Pop <elendil@planet.nl>
To: Gabor Gombas <gombasg@digikabel.hu>
Subject: Re: Linux mdadm superblock question.
Date: Wed, 17 Feb 2010 22:29:05 +0100
User-Agent: KMail/1.9.9
Cc: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, kyle@moffetthome.net,
       neilb@suse.de, babydr@baby-dragons.com, davidsen@tmr.com,
       volkerarmin@googlemail.com, mjevans1983@gmail.com,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
References: <201002140251.59668.volkerarmin@googlemail.com> <201002171426.47981.elendil@planet.nl> <20100217205406.GA13287@twister.home>
In-Reply-To: <20100217205406.GA13287@twister.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002172229.07511.elendil@planet.nl>
X-OriginalArrivalTime: 17 Feb 2010 21:29:08.0166 (UTC) FILETIME=[3CF1BE60:01CAB018]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 February 2010, Gabor Gombas wrote:
> On Wed, Feb 17, 2010 at 02:26:46PM +0100, Frans Pop wrote:
> > That's simply not true, at least not for Debian. If you actually use
> > the distro tools [1] the only assumptions are made at kernel
> > *installation* time, not at kernel build time.
>
> And that's why network-booted diskless clients and virtual guests have
> all sort of useless modules loaded; the HW where the kernel package was
> installed in this case is very different from the HW where the kernel
> will run.

Interesting use case. But also a use case for which initramfs-tools 
probably very simply was never intended.

I agree that in this case you probably want to either
- have a very generic initrd that supports anything (Debian default) [1]
or
- provide a list of modules to include in the initrd based on knowing the
  hardware you want to support (e.g. using /etc/initramfs-tools/modules)
  and prevent including anything based on the host system.

I've never really done that so I don't know if initramfs-tools has any 
features to support that.

> If only there were a switch to prohibit ever looking at the 
> current machine's configuration when generating the initramfs...

Did you ever file a wishlist bug report for that?

> > I've been using initramfs-tools generated initrds for years without
> > problems, and that includes "root on LVM on LUKS encrypted partition"
> > and "root on LVM on RAID" setups.
>
> I've tried a couple of times to use a Debian-built initramfs with a
> custom built kernel. The kernel worked fine without an initramfs (it had
> everything built in), but it did not boot with the initramfs.

It's obviously hard to comment on something like this without more details 
(which would be off-topic for this list).


[1] Could still leave you with problems if the clients use something fancy 
for the root fs that uses info copied from /etc.
