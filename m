Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab0BPNsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 08:48:25 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:23906 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756652Ab0BPNsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 08:48:05 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: Cong Wang <amwang@redhat.com>
Subject: Re: [net-next PATCH v4 1/3] sysctl: refactor integer handling proc code
Date: Tue, 16 Feb 2010 15:44:33 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-2-686; KDE/4.3.2; i686; ; )
Cc: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com> <201002161341.56206.opurdila@ixiacom.com> <4B7A991F.3040601@redhat.com>
In-Reply-To: <4B7A991F.3040601@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002161544.33086.opurdila@ixiacom.com>
X-OriginalArrivalTime: 16 Feb 2010 13:48:02.0757 (UTC) FILETIME=[A8A99750:01CAAF0E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 February 2010 15:09:51 you wrote:
> Octavian Purdila wrote:
> > On Tuesday 16 February 2010 10:41:07 you wrote:
> >>> +static int proc_skip_wspace(char __user **buf, size_t *size)
> >>> +{
> >>> +     char c;
> >>> +
> >>> +     while (*size) {
> >>> +             if (get_user(c, *buf))
> >>> +                     return -EFAULT;
> >>> +             if (!isspace(c))
> >>> +                     break;
> >>> +             (*size)--; (*buf)++;
> >>> +     }
> >>> +
> >>> +     return 0;
> >>> +}
> >>
> >> In lib/string.c we have skip_spaces(), I think we can use it
> >> here instead of inventing another one.
> >
> > I'm afraid we can't, skip_spaces does not accept userspace buffers.
> 
> Well, you need to use copy_from_user() before call it.
> 

And how much would you copy? You need to either use a stack buffer and do a 
loop copy or you would need to copy the whole userspace buffer which means we 
need to allocate a kernel buffer. I think its much cleaner the way is currently 
done.
