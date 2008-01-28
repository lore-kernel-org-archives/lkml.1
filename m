Return-Path: <linux-kernel-owner+w=401wt.eu-S1761405AbYA1QU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbYA1QU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYA1QUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:20:52 -0500
Received: from gw.goop.org ([64.81.55.164]:33813 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbYA1QUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:20:51 -0500
Message-ID: <479E00E0.2030908@goop.org>
Date: Mon, 28 Jan 2008 08:20:48 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 00 of 11] x86: separate pmd lifetime from pgd
References: <patchbomb.1201296189@localhost> <20080128151753.GA14451@elte.hu> <20080128154140.GA17017@elte.hu>
In-Reply-To: <20080128154140.GA17017@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> and after a session of bisection, the winner patch is:
>
>   Subject: x86: unify PAE/non-PAE pgd_ctor
>
> which is a tad unexpected, given the relatively harmless nature of the 
> patch. (but then again, nothing is really harmless in PAE land.)
>   

Oh, well, good.  At least off-the-cuff diagnosis was right.  I must have 
overlooked some detail in that merge.

> btw., this is not fair i think: your patch was apparently caught by the 
> new debugging helper that tells about itself here:
>
>   
>> [   29.389872] debug: unmapping init memory c0b03000..c0b6f000
>>     
>
> note the close proximity of c0b6f000 and ebx = c0b6fc08. [ I regularly 
> come up with such nasty tricks and debugging helpers like that to catch 
> bad patches off-guard. You have been warned! ;-) ]
>   

Hm, perhaps, but it could be as easily coincidence.  The place there 
initmem is freed is close to where it first needs to rely on a 
non-initmm pagetable.  I presume that message means that c0b6f000 was 
*not* freed.

    J
