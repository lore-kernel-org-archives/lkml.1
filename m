Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592Ab0AZA7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab0AZA7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522Ab0AZA7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:59:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54922 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab0AZA7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:59:18 -0500
Message-ID: <4B5E3E22.6030401@zytor.com>
Date: Mon, 25 Jan 2010 16:58:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Yinghai Lu <yinghai@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 22/37] move round_up/down to kernel.h
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org>	<1263611228-6751-23-git-send-email-yinghai@kernel.org>	<alpine.DEB.2.00.1001191155540.22304@router.home>	<4B57675E.7070309@kernel.org> <20100125164032.330be0e6.akpm@linux-foundation.org>
In-Reply-To: <20100125164032.330be0e6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2010 04:40 PM, Andrew Morton wrote:
> 
> The problem is that arch/x86/include/asm/proto.h implements private
> rounding macros.  The right way to fix that is to convert each x86
> "call site" over to using the standard macros from kernel.h, then
> finally remove the private definitions from
> arch/x86/include/asm/proto.h.  Don't just copy them over to kernel.h
> and make things muddier than they already are!
> 
> If during that conversion it is found that the standard macros for some
> reason don't suit the x86 usage sites then please propose
> enhancements/fixes to the existing kernel.h facilities.
> 

They don't.

The kernel-global alignment macros assume that either the alignment
datum (divisor) is a constant, or that it is acceptable to take the hit
of a division.  Unfortunately, we have real use cases where the
alignment (guaranteed to be a power of two) is variable, but we don't
want to take the hit of a full-blown division.

I suspect the global kernel tree has those, too, but it would seem to be
a dramatic change to change to change the existing facilities to assume
power of two alignment...

	-hpa
