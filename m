Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbYJAVEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbYJAVEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYJAVEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:04:34 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:24510 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYJAVEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:04:34 -0400
Message-ID: <48E3E59B.8060900@codemonkey.ws>
Date: Wed, 01 Oct 2008 16:03:23 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.virtualization
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: kvm@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Dan Hecht <dhecht@vmware.com>, LKML <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org,
       "avi@redhat.com" <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       akataria@vmware.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and Linux.
References: <1222881242.9381.17.camel@alok-dev1>	<48E3BBC1.2050607__35819.6151479662$1222884502$gmane$org@goop.org>	<48E3D7A0.3000403@codemonkey.ws> <48E3D8A8.604__13396.6479487301$1222891831$gmane$org@goop.org>
In-Reply-To: <48E3D8A8.604__13396.6479487301$1222891831$gmane$org@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Anthony Liguori wrote:
>> Mmm, cpuid bikeshedding :-)
> 
> My shade of blue is better.
> 
>>> The space 0x40000000-0x400000ff is reserved for hypervisor usage.
>>>
>>> This region is divided into 16 16-leaf blocks.  Each block has the 
>>> structure:
>>>
>>> 0x400000x0:
>>>     eax: max used leaf within the leaf block (max 0x400000xf)
>> Why even bother with this?  It doesn't seem necessary in your proposal.
> 
> It allows someone to incrementally add things to their block in a fairly 
> orderly way.  But more importantly, its the prevailing idiom, and the 
> existing and proposed cpuid schemes already do this, so they'd fit in as-is.

We just leave eax as zero.  It wouldn't be that upsetting to change this 
as it would only keep new guests from working on older KVMs.

However, I see little incentive to change anything unless there's 
something compelling that we would get in return.  Since we're only 
talking about Linux guests, it's just as easy for us to add things to 
our paravirt_ops implementation as it would be to add things using this 
new model.

If this was something that other guests were all agreeing to support 
(even if it was just the BSDs and OpenSolaris), then there may be value 
to it.  Right now, I see no real value in changing the status quo.

Regards,

Anthony Liguori


>     J

