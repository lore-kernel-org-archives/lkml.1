Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbZFDVKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbZFDVKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZFDVKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:10:40 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:44797 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbZFDVKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:10:39 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Dave Jones <davej@redhat.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Date: Thu, 4 Jun 2009 16:01:30 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906041312.45847.lkml@morethan.org> <20090604203313.GA19286@redhat.com>
In-Reply-To: <20090604203313.GA19286@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041601.33400.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu June 4 2009, Dave Jones wrote:
> On Thu, Jun 04, 2009 at 01:12:43PM -0500, Michael S. Zick wrote:
>  > On Thu June 4 2009, Harald Welte wrote:
>  > > On Thu, Jun 04, 2009 at 11:21:28AM -0500, Michael S. Zick wrote:
>  > > 
>  > > > That is one of my pending questions - -
>  > > > (It is included as a comment at the appropriate point in my patchset.)
>  > > > 
>  > > > The VIA processors have MCR's not MTRR's - -
>  > > 
>  > > AFAIK, that was true for processors like the Winhcip / C6, i.e. earlier than
>  > > the C3.  The C3, C7 and later support 8 intel-style MTRR's.
>  > > 
>  > 
>  > Super!  A specific breakage!
>  > 
>  > The c7 setup code is re-using the c6 setup code (MCR's) - -
>  > Will "if 0" out the appropriate parts and arrange for the MTRR setup.
> 
> It's not touching the MCRs.   C7's are family 6. The MCR code is only
> called for family 5. (Winchips)   Look at the switch statement
> in init_centaur()
> 

Yup, mis-read that one - -

        case 6:
                init_c3(c);
                break;

= = = =

But while your here, what is your opinion on this one,
in: int __init pcibios_init(void)

- - - - -
        pci_cache_line_size = 32 >> 2;
        if (c->x86 >= 6
        && (c->x86_vendor == X86_VENDOR_AMD) || (c->x86_vendor == X86_VENDOR_CENTAUR))
                pci_cache_line_size = 64 >> 2;  /* K7 & K8 and VIA C7-M */
        else if (c->x86 > 6 && c->x86_vendor == X86_VENDOR_INTEL)
                pci_cache_line_size = 128 >> 2; /* P4 */

Mike
