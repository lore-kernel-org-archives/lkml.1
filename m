Return-Path: <linux-kernel-owner+w=401wt.eu-S1756424AbZCUAHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbZCUAHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 20:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZCUAHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 20:07:05 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:35450 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZCUAHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 20:07:04 -0400
Message-ID: <49C42F99.5010700@emcraft.com>
Date: Sat, 21 Mar 2009 03:06:49 +0300
From: Ilya Yanok <yanok@emcraft.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "neilb@suse.de" <neilb@suse.de>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       Yuri Tikhonov <yur@emcraft.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 	multiplication
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>	 <49C26D91.10804@intel.com> <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com> <49C41C1E.4060401@zytor.com> <49C4201A.5060905@emcraft.com> <49C425F5.8060309@intel.com>
In-Reply-To: <49C425F5.8060309@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi H. Peter,

H. Peter Anvin wrote:
>> We defined async_pq() function as hardware can do GF multiplication of
>> arbitrary elements and we want to take advantage of this fact. But by
>> the design of ASYNC_TX API we have to provide synchronous version of
>> that function too.
>>
>
> I don't think that makes sense since the algorithm doesn't use
> vector-vector multiplications and there is no need for them.  As such,
> you're actively excluding support for hardware which only provides
> scalar-vector multiplication, even though that is all we need.
>
> In fact, vectorizing the constant doesn't make much sense.

Hm... I have to admit I can't understand your
vector-vector/scalar-vector terminology... What vector space are you
talking about?

async_gen_syndrome() takes element of GF^n(256) and returns result of
scalar multiplication of it with constant ({01}, {02}, {02}^2, ...,
{02}^n) vector.
async_pq() takes two vectors from GF^n(256) and returns their scalar
multiplication.

We need async_pq() function if we want to offload D_x = A * (P + P_{xy})
+ B * (Q + Q_{xy}) part of DD recovery and D_x = (Q + Q_x) * g^{-x} part
of DP recovery.

Regards, Ilya.

