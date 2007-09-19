Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbXISRYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbXISRYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbXISRYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:24:38 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51113 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750910AbXISRYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:24:37 -0400
Date: Wed, 19 Sep 2007 10:24:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, balbir@in.ibm.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc6-mm1 panic (memory controller issue ?)
In-Reply-To: <1190161903.31220.24.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0709191023490.11138@schroedinger.engr.sgi.com>
References: <1190154076.31220.19.camel@dyn9047017100.beaverton.ibm.com>
 <1190161903.31220.24.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007, Badari Pulavarty wrote:

> I think, I found the issue. I am still running tests to
> verify. Does this sound correct ?

Use GFP_LEVEL_MASK (or the equivalent in mm) to mask out the not allowed 
bits. The patch below only addresses issues with the __GFP_HIGHMEM bit. 
There may be others set. See mm/vmalloc.c for examples.

