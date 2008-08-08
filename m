Return-Path: <linux-kernel-owner+w=401wt.eu-S1759187AbYHHTI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbYHHTI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759222AbYHHTIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:08:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43872 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759445AbYHHTIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:08:02 -0400
Message-ID: <489C97FB.2030408@zytor.com>
Date: Fri, 08 Aug 2008 12:01:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Wolfgang Walter <wolfgang.walter@stwm.de>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, viro@ZenIV.linux.org.uk,
       vegard.nossum@gmail.com
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem
 with fpu state changes
References: <200807171653.59177.wolfgang.walter@stwm.de> <20080806201401.GA607@linux-os.sc.intel.com> <200808071823.02364.wolfgang.walter@stwm.de> <200808081236.55172.wolfgang.walter@stwm.de> <20080808185356.GC607@linux-os.sc.intel.com>
In-Reply-To: <20080808185356.GC607@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> 
> I propose to go with wolf's patch which add's kernel_fpu_begin() and
> kernel_fpu_end() around these instructions. This is the correct fix
> (unless there is something wrong in my above understanding).
> 

It's technically overkill, if (and only if!) these instructions don't 
actually touch the SSE state (most likely they're using the SSE 
pipeline, and need this stuff to deal with power management issues.)

However, overkill is a good way to make sure something is dead. 
Applying the patch will make sure we fix the regression, and we can 
worry about optimizing this further post-2.6.27.

	-hpa
