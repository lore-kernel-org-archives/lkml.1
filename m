Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab0BPKwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:52:30 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:9744 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752157Ab0BPKw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:52:28 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: Cong Wang <amwang@redhat.com>
Subject: Re: [net-next PATCH v4 1/3] sysctl: refactor integer handling proc code
Date: Tue, 16 Feb 2010 12:48:56 +0200
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
Message-Id: <201002161248.56598.opurdila@ixiacom.com>
X-OriginalArrivalTime: 16 Feb 2010 10:52:26.0635 (UTC) FILETIME=[20A4F5B0:01CAAEF6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 February 2010 10:41:07 you wrote:

> > +
> > +     if (!write && !first && left && !err)
> > +             err = proc_put_newline(&buffer, &left);
> > +     if (write && !err)
> > +             err = proc_skip_wspace(&buffer, &left);
> > +     if (err == -EFAULT /* do we really need to check for -EFAULT? */ ||
> > +         (write && first))
> > +             return err ? : -EINVAL;
> 
> The logic here seems messy, adding one or two goto's may help?
> 

OK, I'll give it a try. 

What about the EFAULT check, is that really required?
