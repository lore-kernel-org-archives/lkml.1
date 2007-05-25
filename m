Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbXEYAE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbXEYAE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 20:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbXEYAEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 20:04:21 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35871 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbXEYAEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 20:04:21 -0400
Message-ID: <465627FD.9040301@zytor.com>
Date: Thu, 24 May 2007 17:04:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Andi Kleen <ak@suse.de>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Brown, Len" <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
References: <653FFBB4508B9042B5D43DC9E18836F5EE12ED@scsmsx415.amr.corp.intel.com>
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F5EE12ED@scsmsx415.amr.corp.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
> The way new Intel features are being exposed in CPUID is kind of
> changing.

Changing is a VERY BAD THING when it comes to something like CPUID.

> Now we have different CPUID leafs for different kind of features with
> each of them growing much slowly.
> I mean, there is
> monitor-mwait related features in CPUID 5
> powermanagement features in CPUID 6 EAX, ECX
> Perfmon features in CPUID 10

Again, this is bad.

> This does not fit well with the way we use the feature words in Linux.

No, it doesn't... nor for anyone else who wants a compact representation
of this kind of information.

If they grow slowly from the bottom, I guess we could simply allocate
space in the vector byte by byte instead.  Either way, it means more
work whenever anything has to change.

	-hpa
