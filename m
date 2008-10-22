Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYJVSm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYJVSm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYJVSmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:42:19 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:63218 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbYJVSmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:42:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cvm1exxm/Exh1tDD6nt7pNBNGGAPHQ8blQLbOPuNlCSQsOriHVmL4N7mIixcZ4gW10
         pkYFmzbUg7x2XrC189eDn7j1jtEI8TSYbPSiijcpfB8YO1mEq95TazsqxBf+KnoHIjlX
         IoqKSlvbS2tkL3D8Ct/UpVfnWk2mzCGdZLGIM=
Date: Wed, 22 Oct 2008 22:42:12 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLUB - define OO_ macro instead of hardcoded numbers
Message-ID: <20081022184212.GA4218@localhost>
References: <Pine.LNX.4.64.0810220926130.7633@quilx.com> <20081022163530.GH9639@localhost> <20081022165354.GI9639@localhost> <20081022172103.GJ9639@localhost> <Pine.LNX.4.64.0810221037320.7633@quilx.com> <48FF6800.20705@cs.helsinki.fi> <20081022175827.GL9639@localhost> <Pine.LNX.4.64.0810221110060.27088@quilx.com> <20081022181556.GM9639@localhost> <Pine.LNX.4.64.0810221123150.17454@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810221123150.17454@quilx.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Lameter - Wed, Oct 22, 2008 at 11:24:58AM -0700]
> On Wed, 22 Oct 2008, Cyrill Gorcunov wrote:
>
>> [Christoph Lameter - Wed, Oct 22, 2008 at 11:10:56AM -0700]
>>> On Wed, 22 Oct 2008, Cyrill Gorcunov wrote:
>>>
>>>> +#define OO_SHIFT	16
>>>> +#define OO_MASK		((1 << OO_SHIFT) - 1)
>>>> +#define MAX_OBJS_PER_PAGE	65535 /* see struct page.objects */
>>>
>>> This is == OO_MASK right? Otherwise things will break when we change
>>> OO_SHIFT.
>>>
>>
>> Yes, I set it 65535 directly to distinguish it from OO_MASK
>> meaning not value and point to page.objects since they are
>> u16. Which meant that is the point where all limits start.
>> So it we set OO_SHIFT to say 14 it will not be a problem
>> but if we exceed 16 bits it will break SLUB. Am I right?
>> (I become scratching the head :)
>
> If you set it > 16 then the size of the field in struct page is violated.
>
> So
>
> #define MAX_OBJ_PER_PAGE MIN(1 << bits_in(page.objects) - 1, OO_MASK)
>
> ?
>
>

I think the patch becomes more complicated as it should be.
Maybe just use:

#define MAX_OBJ_PER_PAGE 65535 /* since page.objects is u16 */

		- Cyrill -
