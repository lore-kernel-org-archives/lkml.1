Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbZEFMbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbZEFMbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbZEFMav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:30:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39599 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115AbZEFMav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:30:51 -0400
Date: Wed, 6 May 2009 14:30:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rik van Riel <riel@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, mingo@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH] x86: 46 bit PAE support
Message-ID: <20090506123030.GW25203@elte.hu>
References: <20090505172856.6820db22@cuia.bos.redhat.com> <4A00ED83.1030700@zytor.com> <4A0180AB.20108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0180AB.20108@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rik van Riel <riel@redhat.com> wrote:

> H. Peter Anvin wrote:
>> Rik van Riel wrote:
>>> Testing: booted it on an x86-64 system with 6GB RAM.  Did you really think
>>> I had access to a system with 64TB of RAM? :)
>>
>> No, but it would be good if we could test it under Qemu or KVM with an
>> appropriately set up sparse memory map.
>
> I don't have a system with 1TB either, which is how much space
> the memmap[] would take...

Not if the physical layout is sparse. I.e. something silly like:

  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
  BIOS-e820: 0000200000000000 - 0000200040000000 (usable)

Which is 1GB of RAM at 4GB physical offset, and another 1GB of RAM 
at 32 TB physical offset. Takes two gigs of real RAM and a kernel 
modified with your patch, to not get confused by this :-)

	Ingo
