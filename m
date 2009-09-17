Return-Path: <linux-kernel-owner+w=401wt.eu-S1760425AbZIQDyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425AbZIQDyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 23:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760179AbZIQDyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 23:54:21 -0400
Received: from mga10.intel.com ([192.55.52.92]:49478 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760173AbZIQDyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 23:54:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,401,1249282800"; 
   d="scan'208";a="727692207"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [RFC][PATCH 08/10] x86: Don't ack_APIC_irq() if lapic is disabled in GENERIC_INTERRUPT_VECTOR handler
Date: Thu, 17 Sep 2009 11:54:18 +0800
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; x86_64; ; )
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Jun Nakajima <jun.nakajima@intel.com>,
       Eddie Dong <eddie.dong@intel.com>, linux-kernel@vger.kernel.org,
       "xen-devel" <xen-devel@lists.xensource.com>
References: <1253090551-7969-1-git-send-email-sheng@linux.intel.com> <20090916090306.GF5094@lenovo> <20090916093731.GG5094@lenovo>
In-Reply-To: <20090916093731.GG5094@lenovo>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909171154.18924.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 September 2009 17:37:31 Cyrill Gorcunov wrote:
> [Cyrill Gorcunov - Wed, Sep 16, 2009 at 01:03:06PM +0400]
>
> | [Cyrill Gorcunov - Wed, Sep 16, 2009 at 12:58:35PM +0400]
> | ...
> |
> | | Hi Sheng,
> | |
> | | is there was some problem with it? I'm asking you
> | | because if disable_apic=1 then any apic write/read
> | | operations become NOPs. So I don't see how it may
> | | hurt. But I could be missing something.
> | |
> | | 	-- Cyrill
> |
> | Ah, I see -- it's due to your other patch...
> | Hmm this makes all "disable apic" idea less
> | general. And safety of ack_APIC_irq is now
> | under suspicious.

Um, probably. I've seen a ack_APIC_irq() in do_IRQ when handle_irq() fail. 
Seems the assumption that ack_APIC_irq() always safe is there. I will check if 
I can make it more elegant - maybe disable the warning in the Xen code...

> |
> | 	-- Cyrill
>
> And how msi_compose_msg would work then?

As you guessed, Xen also use event channel to handle it for guest(for we 
called "passthrough devices"), the real interrupt delivered to the Xen, then 
delivered through event channel to the guest.
>
> Don't get me wrong please, I'm just trying to understand.
> Perhaps Xen specifics will handle it (I didn't read Xen
> internals) by substituting all this with own handler.
>
> Since comments are requested I thought I may ask? :)

Oh, never mind. Glad to see your comments. :)

-- 
regards
Yang, Sheng

