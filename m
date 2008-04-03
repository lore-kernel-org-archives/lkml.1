Return-Path: <linux-kernel-owner+w=401wt.eu-S1760938AbYDCTcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760938AbYDCTcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760842AbYDCTcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:32:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:12845 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744AbYDCTcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:04 -0400
Message-ID: <47F530AD.3090706@colorfullife.com>
Date: Thu, 03 Apr 2008 21:31:57 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, xemul@openvz.org,
       linux-kernel@vger.kernel.org, sukadev@us.ibm.com, ebiederm@xmission.com,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>
Subject: Re: [RFC, PATCH] fix SEM_UNDO with namespaces
References: <47EFFD1C.5020204@colorfullife.com> <47F08ED6.1090103@openvz.org> <47F10DF7.5010702@colorfullife.com> <47F203EC.7090806@openvz.org> <20080401141540.GB13213@sergelap.ibm.com> <20080403120406.dbc84cbd.akpm@linux-foundation.org>
In-Reply-To: <20080403120406.dbc84cbd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>
>> Absolutely.
>>
>>     
>
> Guys, what's the status here?
>
> afaict Manfred has identified an available-to-unprivileged-apps kernel
> memory corrupter?  If so, we should fix it asap for 2.6.25.  And for
> 2.6.24.x if it's also present there.
>
>   
No, it's a priveledged-only memory corruption:
> int unshare_nsproxy_namespaces(unsigned long unshare_flags,
>                 struct nsproxy **new_nsp, struct fs_struct *new_fs)
> {
>         int err = 0;
> [snip]
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EPERM;

> Manfred's patch doesn't come close to applying against the 2.6.26 IPC
> things which we have queued but that's OK - bugfixes come first.
>   
Where can I find the queued changes? Are they in -mm?

--
    Manfred
