Return-Path: <linux-kernel-owner+w=401wt.eu-S1762230AbZLKMHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230AbZLKMHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 07:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbZLKMHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 07:07:53 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:43425 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbZLKMHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 07:07:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h2Now4d7xid+5bpQO7nXr4kY/8ayf+YYbxgQwkN4lMxr84CZ9J4FexBV4lJCAZ8icU
         HRcnJV+VwLfIpHnFHEoymE+Cf+VSYMZIXAveHKMPn3dK/mro2l/DFa0IojtFjHKwl+AL
         fx9D9/9P50fo37HvGHlzuCEnGJyd+irUdXgxg=
Date: Fri, 11 Dec 2009 13:07:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] tracing/filters: Fix MATCH_FULL filter matching
	for PTR_STRING
Message-ID: <20091211120753.GE5244@nowhere>
References: <4B2217D0.5000308@cn.fujitsu.com> <4B2217EA.4010902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2217EA.4010902@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 05:59:06PM +0800, Li Zefan wrote:
> MATCH_FULL matching for PTR_STRING is not working correctly:
> 
>   # echo 'func == vt' > events/bkl/lock_kernel/filter
>   # echo 1 > events/bkl/lock_kernel/enable
>   ...
>   # cat trace
>    Xorg-1484  [000]  1973.392586: lock_kernel: ... func=vt_ioctl()
>     gpm-1402  [001]  1974.027740: lock_kernel: ... func=vt_ioctl()
> 
> We should pass to regex.match(..., len) the length (including '\0')
> of the source string instead of the length of the pattern string.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>


This patch is cool but it seems to also break middle and end
matching (at least what was working with end matching :)

I know you fix that in the subsequent patches, but please
avoid that. A fix should not bring another known bug,
event if it's fixed in the same batch.

Thanks.

