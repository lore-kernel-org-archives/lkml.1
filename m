Return-Path: <linux-kernel-owner+w=401wt.eu-S1422786AbXBUShH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422786AbXBUShH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422785AbXBUShH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:37:07 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54070 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422786AbXBUShF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:37:05 -0500
Message-ID: <45DC916E.1020300@cs.helsinki.fi>
Date: Wed, 21 Feb 2007 20:37:34 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 1.5.0.9 (Macintosh/20061207)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jsipek@fsl.cs.sunysb.edu, unionfs@filesystems.org, bunk@stusta.de,
       hooanon05@yahoo.co.jp
Subject: Re: [PATCH 1/3] slab: introduce krealloc
References: <Pine.LNX.4.64.0702211003290.8172@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0702210951580.24344@schroedinger.engr.sgi.com> <45DC8DA1.6030100@cs.helsinki.fi> <Pine.LNX.4.64.0702211023300.24719@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0702211023300.24719@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Christoph Lameter wrote:
> 1. Just do not allow shrinking via realloc. Probably no big loss and best 
> performance.

Not a big loss if you can afford the wasted memory. But, I don't think 
we should do this, there's no way for the caller to know that we will 
hold on to the memory indefinitely.

Christoph Lameter wrote:
> 2. Check if the size specified is larger than the next smallest general 
> cache and only copy if we would really would allocate from a different 
> cache.

Yeah, I was thinking about this too but decided against it (for now) as 
I am mostly concerned with removing the slab abuses from unionfs. Also, 
it is not immediately obvious we want to do this for all cases of 
krealloc so I'd prefer to keep the API for a while and decide to 
optimize or not optimize later. Note that we would only get rid of one 
of the kfree callers, the other one doesn't want to do krealloc(), it 
never reuses the old values.

			Pekka

