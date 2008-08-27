Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbYH0Vwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbYH0Vwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbYH0Vw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:52:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:60041 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752546AbYH0Vw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:52:27 -0400
X-Authenticated: #31060655
X-Provags-ID: V01U2FsdGVkX1+DTEkRDCyD+LsjH40tBNivVFbDFC3N+5p7l3O2bI
	9pkjMBUGpkfikn
Message-ID: <48B5CC98.9000904@gmx.net>
Date: Wed, 27 Aug 2008 23:52:24 +0200
From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080316 SUSE/1.1.9-1.1 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Bruce_Leonard@selinc.com, linux-mtd-bounces@lists.infradead.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Bruce Leonard <brucle@earthlink.net>
Subject: Re: [PATCH 2/2] Add support for > 2GiB MTD devices
References: <1219815617.18027.132.camel@sauron>	<OF5BDBDD21.E5375C78-ON882574B2.0061B127-882574B2.00648B63@selinc.com> <20080827185142.GE27491@shareable.org>
In-Reply-To: <20080827185142.GE27491@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.08.2008 20:51, Jamie Lokier wrote:
> Bruce_Leonard@selinc.com wrote:
>   
>> I'm still reluctant to change size to a 64-bit value.  There's a vague 
>> recolection of early conversations on the list that there would be little 
>> acceptance for that.  And that probably has to do with the ongoing 
>> conversation about ABI changes.  What I could do to eliminate the 
>> multiplication is introduce the same concept that the NAND layer uses, 
>> shift values.  After all, erasesize should always be a power of 2, making 
>> that a power of 2 multiplication which can be done via shifts.  By 
>> changing erasesize to erasesize_shift, I'd get something like this:
>>
>> return a->num_eraseblocks == 0 ? a->size : a->num_eraseblocks << 
>> a->erasesize_shift
>>
>> How would that suit you?
>>     
>
> Are you sure it's always going to be a power of 2?
>
> What if someone targets a board with 3 chips wired to shared address
> and parallel data buses?
>
> Or if someone makes a weird chip?  Or if you can format it in
> different ways according to desired ECC level (like you can with CDs)?
>   

IIRC I saw a datasheet for such a chip (selectable erasesize with
non-power-of-2 default) some weeks ago and it had entered production a
few months ago. The erasesize was alwas a multiple of 16, though. Sorry
for not remembering more details.

Regards,
Carl-Daniel

-- 
http://www.hailfinger.org/

