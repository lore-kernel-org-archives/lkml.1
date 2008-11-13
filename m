Return-Path: <linux-kernel-owner+w=401wt.eu-S1752390AbYKMFzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbYKMFzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 00:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbYKMFy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 00:54:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:55316 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbYKMFy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 00:54:58 -0500
Message-ID: <491BC11F.1010709@kernel.org>
Date: Thu, 13 Nov 2008 14:54:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491A96AE.3080600@kernel.org> <E1L0CWu-0004Dk-F9@pomaz-ex.szeredi.hu>
In-Reply-To: <E1L0CWu-0004Dk-F9@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Nov 2008 05:54:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> On Wed, 12 Nov 2008, Tejun Heo wrote:
>>> Comments about the others:
>>>
>>>   0002-FUSE-pass-nonblock-flag-to-client.patch
>>>
>>> this is not needed, f_flags are already passed to userspace for read
>>> and write.
>> Hmmm... I'll try to find out whether I can use f_flags.  There was
>> something that prevented it from working properly.  I'll dig.
> 
> Support for this was missing from libfuse, but now I fixed that in the
> CVS version.

Yeah, right, it can just use fi.flags.  0002 dropped.

>>>   0004-FUSE-implement-direct-lseek-support.patch
>>>
>>> this is trickier to get the interface right I think.  If we want to
>>> allow filesystems to implement a custom lseek, then we also want them
>>> to keep track of the file position, which means we must differentiate
>>> between a write(2) and a pwrite(2) and similarly for reads.  AFAICS
>>> this isn't needed for CUSE so we can leave this to later.
>> Read/write already passes @offset, so the only thing required is an
>> extra flag there.  I mainly wanted a way for a CUSE server to veto lseek
>> with proper error and still think it's better to have this as we don't
>> really know what wacky users are out there.  What do you think about an
>> extra flag?
> 
> OK, but that's gonna involve a fair bit of API churn, and I'm not sure
> it's worth it at this stage.  If this is not needed for the OSS
> emulation, I think we should postpone it.

Alright.

Thanks.

-- 
tejun
