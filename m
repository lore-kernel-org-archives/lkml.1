Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbYJPWsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbYJPWsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbYJPWsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:48:22 -0400
Received: from relay1.sgi.com ([192.48.171.29]:41244 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756203AbYJPWsV (ORCPT
	<rfc822;@relay.corp.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:48:21 -0400
Message-ID: <48F7C4A7.5090708@sgi.com>
Date: Fri, 17 Oct 2008 09:48:07 +1100
From: Timothy Shimmin <tes@sgi.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Jianjun Kong <jianjun@zeuux.org>, Dave Chinner <david@fromorbit.com>,
       stable@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] XFS fix remount rw with unrecognized options
References: <20081016002926.D912558FA22B@chook.melbourne.sgi.com> <20081016134112.GA8773@ubuntu> <20081016223637.GB31761@disturbed>
In-Reply-To: <20081016223637.GB31761@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Thu, Oct 16, 2008 at 09:41:12PM +0800, Jianjun Kong wrote:
>> And the code above "return 0" can not be executed, so delete them.
>> __________________________________________
>> #if 0
>>                         printk(KERN_INFO
>>         "XFS: mount option \"%s\" not supported for remount\n", p);
>>                         return -EINVAL;
>> #else                                                                                                            
>>                         return 0;
>> -----------------------------------------
> 
> That ifdef was added to stub out the behaviour we *actually want*
> remount to have when it encounters an invalid remount option.
> The reason for leaving it is in the next release we should have all
> the other problems we discovered by doing this fixed, so that
> code will be re-enabled. Hence the temporary #if 0 around it.
> 
> So at this point, don't remove it.
> 
> Cheers,
> 
> Dave.

Exactly.
I don't want it removed.
Extra code for comparing existing mount state with new mount state
needs to be done and this code can be reactivated when we sort
this stuff out later.
This patch should be just the fix for the current regression.

Thanks,
--Tim
