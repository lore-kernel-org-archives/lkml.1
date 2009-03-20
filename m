Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbZCTXBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbZCTXBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbZCTXBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:01:01 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:35220 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbZCTXBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:01:00 -0400
Message-ID: <49C4201A.5060905@emcraft.com>
Date: Sat, 21 Mar 2009 02:00:42 +0300
From: Ilya Yanok <yanok@emcraft.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Dan Williams <dan.j.williams@intel.com>,
       "H. Peter Anvin" <h.peter.anvin@intel.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com,
       Yuri Tikhonov <yur@emcraft.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 	multiplication
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>	 <49C26D91.10804@intel.com> <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com> <49C41C1E.4060401@zytor.com>
In-Reply-To: <49C41C1E.4060401@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi H. Peter,

H. Peter Anvin wrote:
>> Something is broken if we take this path.  This routine could stand to
>> have a WARN_ONCE(), because if it is ever called there is something is
>> wrong with the raid6 offload driver.  The intent is that the
>> asynchronous recovery routines will perform an early check to see if
>> the recovery can be offloaded (with a series of calls to
>> async_xor/async_pq).  If not we fall back to the optimized synchronous
>> recovery routines (raid6_2data_recov, raid6_datap_recov).  The only
>> time this path will be taken is if we have decided to perform
>> asynchronous recovery but at a later call to async_pq the offload
>> driver reports it has run out of descriptors.
>>
>
> That doesn't explain what you expect the code to do.  It still doesn't
> make sense to me.

We defined async_pq() function as hardware can do GF multiplication of
arbitrary elements and we want to take advantage of this fact. But by
the design of ASYNC_TX API we have to provide synchronous version of
that function too.

Regards, Ilya.

