Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbYKUP1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbYKUP1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbYKUP11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:27:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:41446 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbYKUP11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:27:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=LEHd+CN17JaFRH8z+F2EWaIySVvXDEb2TkJa017I4AAgYUik+QR8YHDD9HS0Fm6AHq
         XNLDdfbT0syjhMXXdqQoezF6S3lTsA+wnZv9RfglQG54z+j2/dSxg1yF3kfdz4cMRdXB
         Q/N0+JEHcBOhKn98XF9/5GLx67jzsBYSHsQHo=
Message-ID: <7c86c4470811210727o13006d5bk5bcbacb791e51b1c@mail.gmail.com>
Date: Fri, 21 Nov 2008 16:27:25 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: debugctl msr
Cc: "Markus Metzger" <markus.t.metzger@googlemail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <7c86c4470811210538i5e6958e1p2c31effa762f5914@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <7c86c4470811190459y5996f51bp24ab38c9e856c2eb@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10CB1@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190913u743706abgafff3b0f0e3559ec@mail.gmail.com>
	 <1227119245.6025.12.camel@raistlin>
	 <7c86c4470811191120i63b70970s3e24af5c962ea538@mail.gmail.com>
	 <1227133570.6104.10.camel@raistlin>
	 <7c86c4470811201319x2eb93d41vbdd8ce480a797fab@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F115BC@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811210538i5e6958e1p2c31effa762f5914@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,

Ok, I finally got everything working. The interrupt issue was due to a
bug in the perfmon code.

But I found another bug in ds.c.

The absolute maximum MUST be at buffer+size+1 but the threshold can be anywhere
between the start of the buffer and buffer+size. You had it set past
the end of the buffer (at +1),
therefore PEBS was not generating any interrupts.

On Fri, Nov 21, 2008 at 2:38 PM, stephane eranian
<eranian@googlemail.com> wrote:
> Markus,
>
> On Fri, Nov 21, 2008 at 9:22 AM, Metzger, Markus T
> <markus.t.metzger@intel.com> wrote:
>> I also added the interrupt threshold to the parameters of ds_request().
>> It will be fix for one tracing session, if that's OK with you.
>>
> I still need a call to query the threshold.
>
