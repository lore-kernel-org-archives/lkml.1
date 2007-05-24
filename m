Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbXEXWwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbXEXWwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbXEXWv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:51:56 -0400
Received: from terminus.zytor.com ([192.83.249.54]:37767 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758158AbXEXWvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:51:55 -0400
Message-ID: <465616F3.6090501@zytor.com>
Date: Thu, 24 May 2007 15:51:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
References: <20070523224637.GB15887@linux-os.sc.intel.com> <20070524150223.41063046.akpm@linux-foundation.org> <46560E4F.2080009@zytor.com> <20070524224154.GA29337@redhat.com>
In-Reply-To: <20070524224154.GA29337@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Thu, May 24, 2007 at 03:14:39PM -0700, H. Peter Anvin wrote:
> 
>  > pbe collides with abuse by at least two vendors (AMD and
>  > Cyrix/Centaur/VIA) of this bit for 3DNow.
> 
> Unless I'm mistaken,
> 
> pbe comes from cpuid level 1
> 
> 3dnow comes from cpuid level 0x80000001
> though I did notice that amd have it in edx, whilst via have it in ecx
> curiously.

edx is correct.

What you're describing is correct for later-level AMD/Cyrix chips,
however, when 3DNow! was first introduced they foolishly squatted on the
Intel-assigned CPUID flags.

However, I have audited all the vendor initialization paths, and we kill
off that CPUID bit in all the places that matter.

	-hpa
