Return-Path: <linux-kernel-owner+w=401wt.eu-S1763073AbXGJKJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763073AbXGJKJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 06:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758403AbXGJKJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 06:09:49 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:39704 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757576AbXGJKJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 06:09:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=vHWJq0Dd7p+AKZRwPAnN/ktV5G/ExRbUMREluXveT7Dc5noeEPnpyFn0Ip/FS8v8eJnjYd8D3lf2MMesZ+ze9c+CrYj/Dj5prd/oKHwjrOsP5Z1+2ak8Ow6j8m+eCXJdsswCmzsJa5fZAnItzdHUGjrpmrK0QOeNH8ZzXlBIrGc=  ;
X-YMail-OSG: kNRcpLkVM1mgNCpxd8k73pZ054yeR9XdWI9e81fSPOzms_rL.uDA4seuozvaR2DndiG9VLmOpw--
Message-ID: <46935AE5.7050205@yahoo.com.au>
Date: Tue, 10 Jul 2007 20:09:41 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
References: <20070708034952.022985379@sgi.com>	 <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu>	 <20070708110224.9cd9df5b.akpm@linux-foundation.org>	 <4691A415.6040208@yahoo.com.au>	 <84144f020707090404l657a62c7x89d7d06b3dd6c34b@mail.gmail.com>	 <Pine.LNX.4.64.0707090907010.13970@schroedinger.engr.sgi.com>	 <Pine.LNX.4.64.0707101049230.23040@sbz-30.cs.Helsinki.FI>	 <469342DC.8070007@yahoo.com.au> <84144f020707100231p5013e1aer767562c26fc52eeb@mail.gmail.com>
In-Reply-To: <84144f020707100231p5013e1aer767562c26fc52eeb@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Nick,
> 
> Pekka J Enberg wrote:
> 
>> > That's 92 KB advantage for SLUB with debugging enabled and 240 KB when
>> > debugging is disabled.
> 
> 
> On 7/10/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
>> Interesting. What kernel version are you using?
> 
> 
> Linus' git head from yesterday so the results are likely to be
> sensitive to workload and mine doesn't represent real embedded use.

Hi Pekka,

There is one thing that the SLOB patches in -mm do besides result in
slightly better packing and memory efficiency (which might be unlikely
to explain the difference you are seeing), and that is that they do
away with the delayed freeing of unused SLOB pages back to the page
allocator.

In git head, these pages are freed via a timer so they can take a
while to make their way back to the buddy allocator so they don't
register as free memory as such.

Anyway, I would be very interested to see any situation where the
SLOB in -mm uses more memory than SLUB, even on test configs like
yours.

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.
