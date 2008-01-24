Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbYAXVH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbYAXVH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbYAXVHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:07:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbYAXVHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:07:11 -0500
Message-ID: <4798FDF2.3000605@redhat.com>
Date: Thu, 24 Jan 2008 15:06:58 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: dann frazier <dannf@dannf.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.4: fix memory corruption from misinterpreted bad_inode_ops
 return values
References: <20080124061212.GA22079@ldl.fc.hp.com> <20080124195624.GJ8953@1wt.eu>
In-Reply-To: <20080124195624.GJ8953@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> Hi Dann,
> 
> On Wed, Jan 23, 2008 at 11:12:12PM -0700, dann frazier wrote:
>> This is a 2.4 backport of a linux-2.6 change by Eric Sandeen
>> (commit be6aab0e9fa6d3c6d75aa1e38ac972d8b4ee82b8)
>>
>> CVE-2006-5753 was assigned for this issue.
>>
>> I've built and boot-tested this, but I'm not sure how to exercise
>> these codepaths.
> 
> I have no idea either. Let's consider that if nobody on the list knows
> how to do so, I'll merge it since you did not notice any regression.
> 
> Thanks,
> Willy
> 

Sorry... here you go.  Forgot to post this sooner.  I hit it with
this on 2.6.x


#include <stdio.h>
#include <sys/types.h>
#include <sys/errno.h>

static int return_EIO(void)
{
        return -EIO;
}

int main(int argc, char ** argv)
{
	ssize_t error;
	ssize_t realerror = -EIO;
	ssize_t (*fn_ptr)(void);

	fn_ptr = (void *)return_EIO;

	error = (ssize_t)fn_ptr();
	printf("and... error is %ld, should be %ld\n", error, realerror);
	return 0;
}

-Eric
