Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbYKSU7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbYKSU7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 15:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYKSU7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 15:59:36 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:29297 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYKSU7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 15:59:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=B5iTT+eHcQUPVK6DDWBsokXtL1bjhzRVg2rkZ+Xizy4s0hs2WlrDoQQD3+G0DB7aTF
         ZCOa8kJpPL+32xRB2qF02te+ALC12p0pE11wHyJOiAOE4bCYXBhe9Jx+EKZiPlRSbp2x
         7uafJdLiH+xph3ebOH1wXHe/QTo0AmMRShbHI=
Message-ID: <7c86c4470811191253w2c9d9c02i7d1d314f49cb5261@mail.gmail.com>
Date: Wed, 19 Nov 2008 21:53:06 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Markus Metzger" <markus.t.metzger@googlemail.com>
Subject: Re: debugctl msr
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <7c86c4470811191120i63b70970s3e24af5c962ea538@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <7c86c4470811141310h4fd3c5fbvc6357985cf2aed0e@mail.gmail.com>
	 <1226743286.6162.6.camel@raistlin>
	 <7c86c4470811181400r1fa56ef9o1931467ee10e4f52@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10AAA@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190459y5996f51bp24ab38c9e856c2eb@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10CB1@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190913u743706abgafff3b0f0e3559ec@mail.gmail.com>
	 <1227119245.6025.12.camel@raistlin>
	 <7c86c4470811191120i63b70970s3e24af5c962ea538@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,


On Wed, Nov 19, 2008 at 8:20 PM, stephane eranian
<eranian@googlemail.com> wrote:
>
>> For a single ds_release() call matching a corresponding successful
>> ds_request() call, the buffer is freed if and only if it had been
>> allocated by ds.c.
>>
>> Kfree() itself handles NULL pointers and scripts/checkpatch.pl warns on
>> a check for NULL around a kfree() call.
>>
> Yes, I have narrowed this down to the following lines:
>        current->mm->total_vm  -= context->pages[qual];
>        current->mm->locked_vm -= context->pages[qual];

To follow-up on this, the other issue with this code is that you
should not decrease
those two mm fields  if the buffer was not allocated by ds.c. So I
think, the modification
I sent you in my patch is actually valid (just for another reason).
