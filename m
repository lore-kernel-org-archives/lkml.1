Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbZLNMV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbZLNMV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757179AbZLNMV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:21:28 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33974 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140AbZLNMV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:21:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gizO/6emUKQ0B4Lr/5SH21CuwQeDqNcP576E1m9eT0u4bDWDPFXS+KB2v5jVUxiwtc
         2h2KR9qe65S3yUrhdBLmvm9VD+K2W7WYypA6tULSD/IIWRLZ2CLPCZQpH/QwIyHQCqdh
         Y57cVdUGzVQR/Hlo0keKFy8y1QCxwh/5heg84=
Date: Mon, 14 Dec 2009 13:21:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] tracing/filters: Fix MATCH_FULL filter matching for
	PTR_STRING
Message-ID: <20091214122121.GH5168@nowhere>
References: <4B2217D0.5000308@cn.fujitsu.com> <4B2217EA.4010902@cn.fujitsu.com> <20091211120753.GE5244@nowhere> <4B2597A8.7020909@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2597A8.7020909@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 09:40:56AM +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> > On Fri, Dec 11, 2009 at 05:59:06PM +0800, Li Zefan wrote:
> >> MATCH_FULL matching for PTR_STRING is not working correctly:
> >>
> >>   # echo 'func == vt' > events/bkl/lock_kernel/filter
> >>   # echo 1 > events/bkl/lock_kernel/enable
> >>   ...
> >>   # cat trace
> >>    Xorg-1484  [000]  1973.392586: lock_kernel: ... func=vt_ioctl()
> >>     gpm-1402  [001]  1974.027740: lock_kernel: ... func=vt_ioctl()
> >>
> >> We should pass to regex.match(..., len) the length (including '\0')
> >> of the source string instead of the length of the pattern string.
> >>
> >> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > 
> > This patch is cool but it seems to also break middle and end
> > matching (at least what was working with end matching :)
> > 
> 
> No, it won't, unless I miss something.
> 
> I changed what value ptr_string passes the length param to match(),
> but this param is not used in match_middle and match_end.
> 
> It does break match_front for ptr_string, but that's because
> the mixture of 2 bugs happened to make things right. I can
> sort this out by reordering the 2 patches.


I made a mistake. I meant it breaks match front. As previously it
was taking the pattern length as a parameter and now it takes
the string length to compare.

But well, the things were so broken already that I'm not sure
we need bisectable deltas... :)

