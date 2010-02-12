Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab0BLMKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 07:10:10 -0500
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:24969 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431Ab0BLMKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 07:10:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBAOfTdEt8lZlU/2dsb2JhbAAH2jIChFYE
X-IronPort-AV: E=Sophos;i="4.49,460,1262534400"; 
   d="scan'208";a="19929826"
Message-ID: <4B75451A.5050600@snapgear.com>
Date: Fri, 12 Feb 2010 22:10:02 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: uclinux-dev@uclinux.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: m68knommu: duplicate _ramvec[vba+CPMVEC_RISCTIMER] assignment
 in init_IRQ()
References: <4B72BE49.70803@gmail.com>
In-Reply-To: <4B72BE49.70803@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roel,

On 02/11/2010 12:10 AM, Roel Kluin wrote:
> Looking at arch/m68knommu/platform/68360/ints.c I noted two things that
> stood out:
>
> 1) on line 110:
>
> _ramvec[vba+CPMVEC_RISCTIMER]   = inthandler;  /* reserved */
>
> and 114:
>
> _ramvec[vba+CPMVEC_RISCTIMER]   = inthandler;  /* timer table */
>
> The same definitions are used, and in the first case the comment and
> definition do not correspond.

Yes, that does look odd. I am not intimately familiar with the 68360,
but looking at the underlying vector numbers I would say that the
entry with the "reserved" comment is superfluous, and should be removed.

(That code has been that way as far back as I could see,
certainly into 2.4 kernels).


> 2) while all other definitions are used like this:
>
> _ramvec[vba+CPMVEC_DEF2]   = inthandler;
> ...
> _ramvec[vba+CPMVEC_DEF1]   = inthandler;
>
> This is not true for CPMVEC_RESERVED:
>
> _ramvec[vba+CPMVEC_RESERVED1]   = inthandler;   /* reserved */
> ...
> _ramvec[vba+CPMVEC_RESERVED2]   = inthandler;  /* reserved */
>
> Is this a bug?

I am not sure I follow. Is it the ascending/descending numerical
ordering that you are worried about?

I don't know why the original author ordered the assignments
in the opposite order of the definitions, but I don't see it
making any difference here. So I don't see a bug.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close,                            FAX:         +61 7 3891 3630
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
