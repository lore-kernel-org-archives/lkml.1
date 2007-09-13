Return-Path: <linux-kernel-owner+w=401wt.eu-S1764262AbXIMTzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764262AbXIMTzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 15:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760463AbXIMTyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 15:54:52 -0400
Received: from mga10.intel.com ([192.55.52.92]:54352 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755675AbXIMTyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 15:54:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,251,1186383600"; 
   d="scan'208";a="305481546"
Message-ID: <46E99586.90905@ichips.intel.com>
Date: Thu, 13 Sep 2007 12:54:46 -0700
From: Sean Hefty <mshefty@ichips.intel.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Steve Wise <swise@opengridcomputing.com>
CC: rdreier@cisco.com, sean.hefty@intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH v2] iw_cxgb3: Support "iwarp-only" interfaces
 to avoid 4-tuple conflicts.
References: <20070913191617.30937.95960.stgit@dell3.ogc.int>
In-Reply-To: <20070913191617.30937.95960.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The iWARP driver must translate all listens on address 0.0.0.0 to the
> set of rdma-only ip addresses for the device in question.  This prevents
> incoming connect requests to the TCP ipaddresses from going up the
> rdma stack.

I've only given this a high level review at this point, and while the 
patch looks okay on first pass, is there a way to move some of this 
functionality to either the rdma_cm or iw_cm?  I don't like the idea of 
every iwarp driver having to implement address/listen list maintenance. 
  I may have some ideas after re-examining it.

> Implementation Details:

There are a couple of areas that I made a note to look at in more detail 
(because I didn't understand everything that was happening), but I did 
have one minor nit - most uses of list_del_init can just be list_del.

- Sean
