Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab0BPLqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 06:46:00 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:27930 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753929Ab0BPLp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 06:45:58 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: Cong Wang <amwang@redhat.com>
Subject: Re: [net-next PATCH v4 1/3] sysctl: refactor integer handling proc code
Date: Tue, 16 Feb 2010 13:41:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-2-686; KDE/4.3.2; i686; ; )
Cc: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com> <1266271241-6293-2-git-send-email-opurdila@ixiacom.com> <4B7A5A23.3080309@redhat.com>
In-Reply-To: <4B7A5A23.3080309@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002161341.56206.opurdila@ixiacom.com>
X-OriginalArrivalTime: 16 Feb 2010 11:45:56.0773 (UTC) FILETIME=[9A092550:01CAAEFD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 February 2010 10:41:07 you wrote:

> > +static int proc_skip_wspace(char __user **buf, size_t *size)
> > +{
> > +     char c;
> > +
> > +     while (*size) {
> > +             if (get_user(c, *buf))
> > +                     return -EFAULT;
> > +             if (!isspace(c))
> > +                     break;
> > +             (*size)--; (*buf)++;
> > +     }
> > +
> > +     return 0;
> > +}
> 
> In lib/string.c we have skip_spaces(), I think we can use it
> here instead of inventing another one.
> 

I'm afraid we can't, skip_spaces does not accept userspace buffers.
