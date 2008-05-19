Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbYESDrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbYESDrY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 23:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbYESDrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 23:47:16 -0400
Received: from relay1.sgi.com ([192.48.171.29]:60963 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754424AbYESDrP (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 23:47:15 -0400
Message-ID: <4830F831.40102@sgi.com>
Date: Mon, 19 May 2008 13:46:57 +1000
From: Timothy Shimmin <tes@sgi.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: David Greaves <david@dgreaves.com>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>, asg-qa <asgqa@sgi.com>
Subject: Re: Regression- XFS won't mount on partitioned md array
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net> <482EEFDA.50101@dgreaves.com> <482EF6A7.2020909@sandeen.net> <482F67D9.70400@sandeen.net> <482FBD4C.20608@sandeen.net>
In-Reply-To: <482FBD4C.20608@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>
>>> I'll see if I have a little time today to track down the problem.
>>
>> Does this patch fix it for you?  Does for me though I can't yet explain
>> why ;)
>>
>> http://www.linux.sgi.com/archives/xfs/2008-05/msg00190.html
>>
>> -Eric
> 
> So what's happening is that xfs is trying to read a page-sized IO from
> the last sector of the log... which goes off the end of the device.
> This looks like another regression introduced by
> a9759f2de38a3443d5107bddde03b4f3f550060e, but fixed by Christoph's patch
> in the URL above, which should be headed towards -stable.
> 
> (aside: it seems that this breaks any external log setup where the log
> consists of the entire device... but I'd have expected the xfsqa suite
> to catch this...?)
> 
The only way I can see that we'd catch this (by testing external logs)
in the current qa setup is
if one sets up SCRATCH_LOGDEV and/or TEST_LOGDEV and USE_EXTERNAL.
There are no specific tests to test out external logs (there is 044 but
it requires the env vars set anyway) such as using a loop back device
for the log. Perhaps we should do this.
I should check that our QA group are setting the vars in some runs.

--Tim




