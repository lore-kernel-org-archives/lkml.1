Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbZEUIml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbZEUIml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 04:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZEUImd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 04:42:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:51533 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbZEUImb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 04:42:31 -0400
Message-ID: <4A1513B8.90105@kernel.org>
Date: Thu, 21 May 2009 17:41:28 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 08/20] sysfs: Optimize just changing the sysfs file mode.
References: <m1bppofm9k.fsf@fess.ebiederm.org>	<1242865694-2100-1-git-send-email-ebiederm@xmission.com>	<1242865694-2100-2-git-send-email-ebiederm@xmission.com>	<1242865694-2100-3-git-send-email-ebiederm@xmission.com>	<1242865694-2100-4-git-send-email-ebiederm@xmission.com>	<1242865694-2100-5-git-send-email-ebiederm@xmission.com>	<1242865694-2100-6-git-send-email-ebiederm@xmission.com>	<1242865694-2100-7-git-send-email-ebiederm@xmission.com>	<1242865694-2100-8-git-send-email-ebiederm@xmission.com>	<4A1502C6.5020103@kernel.org> <m1skiy3n85.fsf@fess.ebiederm.org>
In-Reply-To: <m1skiy3n85.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 08:41:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Eric W. Biederman wrote:
>> One visible difference is lack of timestamp update.  Is there any use
>> case where sysfs file mode changing needs to be fast?\
> 
> Not really.  If the time changes we set something besides ATTR_MODE
> like ATTR_MTIME or ATTR_CTIME.  If we come in through any of the
> user space entry points ATTR_CTIME appears to be set so this optimization
> will not trigger.
> 
> I think there are cases where we only opportunistically track time
> changes, when the structure is allocated that this changes but it
> is a very small percentage of the time.
> 
> The practical effect of my changes should be that we only track timestamps
> when user space actually performs an explicit change to the file.
> 
> If someone was depending on some weird indirect side effect like that
> on one of the 5-6 files that calls sysfs_chmod let's make it explicit.
> 
> For me this isn't about making this go faster.  This is about keeping
> the sysfs data structures small when we can.
> 
> It doesn't really complicate the code and we wind up doing the obvious thing.

Well, it doesn't add a lot of complexity but also seems pointless when
there basically is no use case which would benefit from this change.
I suppose it's upto the maintainer.  Greg?

Thanks.

-- 
tejun
