Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbZLBO7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbZLBO7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbZLBO7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:59:40 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:54370 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbZLBO7j convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;7:1>);
	Wed, 2 Dec 2009 09:59:39 -0500
Message-Id: <4B168EEE02000078000230D5@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 02 Dec 2009 14:59:42 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Avi Kivity" <avi@redhat.com>
Cc: <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       <tglx@linutronix.de>, <torvalds@linux-foundation.org>,
       <mingo@redhat.com>, <npiggin@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-tip-commits@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [tip:core/locking] locking, x86: Slightly shorten	
	 __ticket_spin_trylock()
References: <4B0FF9AC0200007800022713@vpn.id2.novell.com>
 <tip-133ec7a235160dd44cbd4d82fff65a9983331df9@git.kernel.org>
 <20091202132937.GA1564@elte.hu>
 <4B168293020000780002308E@vpn.id2.novell.com>
 <4B1675CA.1020504@redhat.com>
 <4B1686F702000078000230A6@vpn.id2.novell.com>
 <4B167B77.8030502@redhat.com>
In-Reply-To: <4B167B77.8030502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Avi Kivity <avi@redhat.com> 02.12.09 15:36 >>>
>On 12/02/2009 04:25 PM, Jan Beulich wrote:
>>>>> Avi Kivity<avi@redhat.com>  02.12.09 15:12>>>
>>>>>          
>>> Wouldn't 'u8 ret', as an additional argument be sufficient? gcc still
>>> ought to be able to use the same register for new and ret if we remove
>>> the early clobber.
>>>      
>> We can't (validly) remove the early-clobber, otherwise the compiler
>> would be permitted to use a register also used for addressing the lock
>> structure for "new".
>>    
>
>I meant for 'ret'.

But unless you drop the early-clobber on new, the compiler will have
to allocate another register, which I think is not desirable here.

Jan

