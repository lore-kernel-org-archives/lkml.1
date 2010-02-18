Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447Ab0BRRmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:42:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41097 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226Ab0BRRmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:42:49 -0500
Message-ID: <4B7D7AF9.9060600@zytor.com>
Date: Thu, 18 Feb 2010 09:38:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jerome Glisse <glisse@freedesktop.org>, suresh.b.siddha@intel.com,
       venkatesh.pallipadi@intel.com, thellstrom@vmware.com, airlied@linux.ie,
       currojerez@riseup.net, linux-kernel@vger.kernel.org
Subject: Re: Uncool feature for TTM introduced by x86, pat: Use page flags
 to track memtypes of RAM pages
References: <20100218153032.GA4506@localhost.localdomain> <87aav65u9g.fsf@basil.nowhere.org>
In-Reply-To: <87aav65u9g.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 09:27 AM, Andi Kleen wrote:
> Jerome Glisse <glisse@freedesktop.org> writes:
>>
>> Can we modify the interface to support again changing from uc to wc
>> or wc to uc ? (i can try to do a patch for that).
> 
> At least on Intel CPUs that support self-snoop (all modern
> ones) that should really be very cheap.
> 

The UC/WC transition should be particularly trivial; I don't see any
reason it should have to go through any other procedure on *any* CPU --
selfsnoop shouldn't even figure into it, since neither UC nor WC
actually caches anything.  For the WC->UC direction, all we should need
to do is to flush the write combiners; a simple wmb() will do that.

Self-snoop is about not having to flush something that can have been
cached, as is normally needed to do WB/WT/WP -> UC/WC.

	-hpa

