Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbYH0VTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbYH0VTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYH0VTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:19:36 -0400
Received: from gw.goop.org ([64.81.55.164]:36907 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbYH0VTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:19:35 -0400
Message-ID: <48B5C4E3.3000002@goop.org>
Date: Wed, 27 Aug 2008 14:19:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: David Vrabel <david.vrabel@csr.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Roland Dreier <rdreier@cisco.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>, torvalds@linux-foundation.org
Subject: Re: [patch] Add helper macros for little-endian bitfields
References: <48AD6AF0.3050504@csr.com> <48AD6B93.7020702@csr.com> <adaprnxnac8.fsf@cisco.com> <20080825014311.GS28946@ZenIV.linux.org.uk> <48B570D6.7070301@csr.com>
In-Reply-To: <48B570D6.7070301@csr.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Vrabel wrote:
> Al Viro wrote:
>   
>> On Sun, Aug 24, 2008 at 06:37:43PM -0700, Roland Dreier wrote:
>>     
>>>  > + * NOTE: When using multibyte bitfields, you need to convert the data
>>>  > + *       from Little Endian to CPU before you can access the bitfield
>>>  > + *       (to make it simpler):
>>>       
>> NOTE: When tempted to use multibyte bitfields on fixed-layout data, you
>> need to look in the mirror, ask yourself "what will they do to me during
>> code review for that?", shudder and decide that some temptations are
>> just not worth the pain.
>>     
>
> But why is this worthy of a crispy flaming?  I've not seen anything
> definite beyond a somewhat vague 'some compilers don't optimize
> bitfields very well'.
>
> The structure definition and the DECL_BF_LEx() macros might be ugly but
> the code using the structures is clearer.  For example,
>
>     get_random_bytes(&tiebreaker, sizeof(unsigned));
>     drp_ie->tiebreaker = tiebreaker & 1;
>
> versus
>
>     get_random_bytes(&tiebreaker, sizeof(unsigned));
>     drp_ie->drp_control |= (tiebreaker & 1)
>             ? UWB_DRP_IE_DRP_CTRL_TIEBREAKER : 0;
>   

Why not just

	drp_ie->drp_control |= tiebreaker & UWB_DRP_IE_DRP_CTRL_TIEBREAKER;

then?  Doesn't matter which random bit you pick, does it?

    J
