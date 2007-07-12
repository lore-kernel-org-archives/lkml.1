Return-Path: <linux-kernel-owner+w=401wt.eu-S936284AbXGLDA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936284AbXGLDA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 23:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934073AbXGLDAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 23:00:48 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:45373 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933964AbXGLDAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 23:00:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Sem2Msce5W9QJuzpkWM6LpqQj5t4RPHAUJeF902eAeDMh/DS3xh1BpRaYZw7h/HVYGRX6Nfa/nWDmOmAaM9VH0m6eYWW8xsnmxrlTdc32eRt5exo6fUi8hoBeCY3Vh2Xq66gFbP8SpVCA4PJdscoBLLiFwCzGi/MsZZ+y8tVbiM=
Message-ID: <46959958.6080005@gmail.com>
Date: Thu, 12 Jul 2007 12:00:40 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: =?UTF-8?B?WU9TSElGVUpJIEhpZGVha2kgLyDlkInol6Toi7HmmI4=?= 
	<yoshfuji@linux-ipv6.org>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/61] sysfs: make sysfs_put() ignore NULL sd
References: <11841968512510-git-send-email-gregkh@suse.de>	<20070712.085047.37780825.yoshfuji@linux-ipv6.org>	<20070711235529.GA7485@suse.de> <20070712.100617.14203407.yoshfuji@linux-ipv6.org>
In-Reply-To: <20070712.100617.14203407.yoshfuji@linux-ipv6.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

YOSHIFUJI Hideaki / 吉藤英明 wrote:
> In article <20070711235529.GA7485@suse.de> (at Wed, 11 Jul 2007 16:55:29 -0700), Greg KH <gregkh@suse.de> says:
> 
>> On Thu, Jul 12, 2007 at 08:50:47AM +0900, YOSHIFUJI Hideaki / ?$B5HF#1QL@ wrote:
>>> In article <11841968512510-git-send-email-gregkh@suse.de> (at Wed, 11 Jul 2007 16:31:43 -0700), Greg Kroah-Hartman <gregkh@suse.de> says:
>>>
>>>> Make sysfs_put() ignore NULL sd instead of oopsing.
>>> I do not think this is a good idea; it is non-sense (and rather a bug)
>>> to call "put" with NULL argument in general.
>> It's better than having to check it all the time in the caller :)
> 
> How many callers do we have that will get benefit from this change?
> 
> Well, the change will hide the bug. It seems all callers in fs/sysfs
> already assume that the argument is NOT NULL, and it is a bug to call
> sysfs_put() with NULL; the function should be used to "put" something
> you "have" (non-NULL). If it is called with NULL, I would say, we
> should BUG here to detect the logical bug.

Well, I'm okay either way.  It's not like one way is undisputably better
than the other but we're leaning toward accepting NULL argument in this
type of functions.  Think about kfree(NULL) and its usefulness.  More
importantly, the ecosystem around sysfs - that is, kobject, driver model
- generally accepts NULL argument for their get/put functions, so unless
there's a compelling reason to convert them all, and I don't see any,
sysfs_put() needs to follow the same rule.

-- 
tejun
