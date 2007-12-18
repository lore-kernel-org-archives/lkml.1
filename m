Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbXLRVJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbXLRVJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXLRVJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:09:52 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:36259 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbXLRVJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:09:51 -0500
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: akepner@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       grundler@parisc-linux.org, jbarnes@virtuousgeek.org, jes@sgi.com,
       randy.dunlap@oracle.com, James.Bottomley@steeleye.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dma: passing "attributes" to dma_map_* routines
X-Message-Flag: Warning: May contain useful information
References: <20071218001758.GO21916@sgi.com>
	<4767FA62.9060002@s5r6.in-berlin.de> <20071218200759.GE412@sgi.com>
	<476834AC.9050401@s5r6.in-berlin.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 18 Dec 2007 13:09:49 -0800
In-Reply-To: <476834AC.9050401@s5r6.in-berlin.de> (Stefan Richter's message of "Tue, 18 Dec 2007 21:59:24 +0100")
Message-ID: <adar6hj1zhe.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Dec 2007 21:09:50.0090 (UTC) FILETIME=[53835EA0:01C841BA]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > However, your older patch series looks like you want this behavior also
 > in areas which are mapped by dma_map_sg(), do you?.  Still, adding two
 > functions of the kind like above, if necessary, might still be
 > preferable to changing the call parameters of existing functions or to
 > overloading enum dma_data_direction.

Yes, the _sg variants are needed, because we want to map userspace
regions with this attribute and there's of course no guarantee that
userspace memory is contiguous.

 - R.
