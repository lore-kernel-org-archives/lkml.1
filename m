Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbZCTWoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbZCTWoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 18:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZCTWoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 18:44:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36037 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbZCTWoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 18:44:08 -0400
Message-ID: <49C41C1E.4060401@zytor.com>
Date: Fri, 20 Mar 2009 15:43:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: "H. Peter Anvin" <h.peter.anvin@intel.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com,
       Ilya Yanok <yanok@emcraft.com>, Yuri Tikhonov <yur@emcraft.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 	multiplication
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>	 <49C26D91.10804@intel.com> <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com>
In-Reply-To: <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> 
> Something is broken if we take this path.  This routine could stand to
> have a WARN_ONCE(), because if it is ever called there is something is
> wrong with the raid6 offload driver.  The intent is that the
> asynchronous recovery routines will perform an early check to see if
> the recovery can be offloaded (with a series of calls to
> async_xor/async_pq).  If not we fall back to the optimized synchronous
> recovery routines (raid6_2data_recov, raid6_datap_recov).  The only
> time this path will be taken is if we have decided to perform
> asynchronous recovery but at a later call to async_pq the offload
> driver reports it has run out of descriptors.
> 

That doesn't explain what you expect the code to do.  It still doesn't 
make sense to me.

	-hpa
