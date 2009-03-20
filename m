Return-Path: <linux-kernel-owner+w=401wt.eu-S1762154AbZCTXle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762154AbZCTXle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763095AbZCTXZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:25:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:55970 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763060AbZCTXZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:25:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,397,1233561600"; 
   d="scan'208";a="674719637"
Message-ID: <49C425F5.8060309@intel.com>
Date: Fri, 20 Mar 2009 16:25:41 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ilya Yanok <yanok@emcraft.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "neilb@suse.de" <neilb@suse.de>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       Yuri Tikhonov <yur@emcraft.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 	multiplication
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>	 <49C26D91.10804@intel.com> <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com> <49C41C1E.4060401@zytor.com> <49C4201A.5060905@emcraft.com>
In-Reply-To: <49C4201A.5060905@emcraft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ilya Yanok wrote:
>>>
>> That doesn't explain what you expect the code to do.  It still doesn't
>> make sense to me.
> 
> We defined async_pq() function as hardware can do GF multiplication of
> arbitrary elements and we want to take advantage of this fact. But by
> the design of ASYNC_TX API we have to provide synchronous version of
> that function too.
> 

I don't think that makes sense since the algorithm doesn't use 
vector-vector multiplications and there is no need for them.  As such, 
you're actively excluding support for hardware which only provides 
scalar-vector multiplication, even though that is all we need.

In fact, vectorizing the constant doesn't make much sense.

	-hpa

