Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbYHTQ3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbYHTQ3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYHTQ3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:29:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:27119 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbYHTQ3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:29:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=enbULzZrldmWdKa8D8BstAHX7WlJhadCnoQzKm0ms0+5Kt733+nmmbvQAfzSZpkdif
         Hw3vbxpldPwAlkUt7toRvWLAX6oSgIQg9ShthWJYcjrP7dyb5e7yTeTplh7UU+wj2hnk
         GzcJHDBwXV7lhFzbGdXw1Fv0UiW5fhuP+tR+s=
Message-ID: <2c0942db0808200929r640b3a1cj33efc56cfd6db9b3@mail.gmail.com>
Date: Wed, 20 Aug 2008 09:29:28 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: VolanoMark regression with 2.6.27-rc1
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, adobriyan@gmail.com,
       "Ingo Molnar" <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       "Aneesh Kumar KV" <aneesh.kumar@linux.vnet.ibm.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       "Chris Friesen" <cfriesen@nortel.com>
In-Reply-To: <200808210110.37204.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1912217169.25608.228.camel@ymzhang>
	 <20080820143209.GA32156@x200.localdomain>
	 <1219242796.8651.54.camel@twins>
	 <200808210110.37204.nickpiggin@yahoo.com.au>
X-Google-Sender-Auth: c321899a3b62e6be
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 8:10 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Thursday 21 August 2008 00:33, Peter Zijlstra wrote:
>> On Wed, 2008-08-20 at 18:32 +0400, adobriyan@gmail.com wrote:
>> > On Wed, Aug 20, 2008 at 03:32:17PM +0200, Peter Zijlstra wrote:
>
>> > > +#define avg(x, y) ({                             \
>> > > + typeof(x) _avg1 = ((x)+1)/2;            \
>> > > + typeof(x) _avg2 = ((y)+1)/2;            \
>> >
>> > ITYM, typeof(y)
>>
>> you thought right, I did mean that :-)
>>
>> > > + (void) (&_avg1 == &_avg2);              \
>> > > + _avg1 + _avg2; })
>
> I don't think this implementation of avg should go in kernel.h?
>
> It gives an average of 1 and 1 to be 2, 3 and 3 is 4, 1 and 3 is
> 3 etc.
>
> Maybe it is reasonable for very high numbers that would overflow
> if added first, but it doesn't seem reasonable for a generic
> averaging function.

The usual way of averaging numbers that may be large is

#define avg(x, y) ({            \
       typeof(x) _x = (x);      \
       typeof(x) _y = (y);      \
       (void) (&_x == &_y);     \
       _x + (_y - _x)/2; })

...which also works for small and negative numbers.
