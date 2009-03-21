Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbZCUCbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbZCUCbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 22:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZCUCb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 22:31:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53841 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbZCUCb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 22:31:26 -0400
Message-ID: <49C45159.8020503@zytor.com>
Date: Fri, 20 Mar 2009 19:30:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ilya Yanok <yanok@emcraft.com>
CC: "H. Peter Anvin" <h.peter.anvin@intel.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "neilb@suse.de" <neilb@suse.de>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       Yuri Tikhonov <yur@emcraft.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 	multiplication
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>	 <49C26D91.10804@intel.com> <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com> <49C41C1E.4060401@zytor.com> <49C4201A.5060905@emcraft.com> <49C425F5.8060309@intel.com> <49C42F99.5010700@emcraft.com>
In-Reply-To: <49C42F99.5010700@emcraft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ilya Yanok wrote:
> 
> async_gen_syndrome() takes element of GF^n(256) and returns result of
> scalar multiplication of it with constant ({01}, {02}, {02}^2, ...,
> {02}^n) vector.

For any n (which would mean any GF field)?  In that case, that is
generic scalar-vector multiplication...

> async_pq() takes two vectors from GF^n(256) and returns their scalar
> multiplication.
> 
> We need async_pq() function if we want to offload D_x = A * (P + P_{xy})
> + B * (Q + Q_{xy}) part of DD recovery and D_x = (Q + Q_x) * g^{-x} part
> of DP recovery.


No, you don't.  A and B (and g^{-x}) are scalars, meaning they're the
same for every element.  This is simpler to do.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

