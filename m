Return-Path: <linux-kernel-owner+w=401wt.eu-S1758832AbXISK5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbXISK5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 06:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbXISK47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 06:56:59 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:45464 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbXISK46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 06:56:58 -0400
Date: Wed, 19 Sep 2007 14:56:13 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Steve Wise <swise@opengridcomputing.com>
Cc: rdreier@cisco.com, sean.hefty@intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [PATCH v2] iw_cxgb3: Support "iwarp-only" interfaces to avoid 4-tuple conflicts.
Message-ID: <20070919105612.GA31158@2ka.mipt.ru>
References: <20070913191617.30937.95960.stgit@dell3.ogc.int> <20070914130941.GG18517@2ka.mipt.ru> <46EC00BE.3020801@opengridcomputing.com> <20070916142241.GA26848@2ka.mipt.ru> <46EE9C50.7070406@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EE9C50.7070406@opengridcomputing.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve.

On Mon, Sep 17, 2007 at 10:25:04AM -0500, Steve Wise (swise@opengridcomputing.com) wrote:
> >Does creating the whole new netdevice is a too big overhead, or is it
> >considered bad idea?
> 
> I think its too big overhead, and pretty invasive on the low level cxgb3 
> driver.  I think having a device in the 'ifconfig -a' after iw_cxgb3 is 
> loaded and devices discovered would be a good thing for the admin.  This 
> is the angle Roland suggested.  I'm just not sure how to implement it.
> 
> But if someone could explain how I might create this full netdevice as a 
> pseudo device on top of the real one, maybe I could implement it.
> 
> Note that non TCP traffic still needs to utilize this interface for ND 
> to work properly with the RDMA core.

Just a though - what about allowing secondary addresses with the same
address as main one? I.e. change bit of the core code to allow creating
aliases with the same address as main device, so that you would be able
to create ':iw' alias during rdma device initialization?

If this solution is not acceptible, then I belive your alias change is
the way to go.

-- 
	Evgeniy Polyakov
