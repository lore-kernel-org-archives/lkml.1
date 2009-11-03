Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbZKCOIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbZKCOIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbZKCOIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:08:45 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57660 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbZKCOIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:08:44 -0500
Date: Tue, 3 Nov 2009 23:07:47 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Americo Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v4] Added PR_SET_PROCTITLE_AREA option for prctl()
Cc: kosaki.motohiro@jp.fujitsu.com, Timo Sirainen <tss@iki.fi>,
       Bryan Donlan <bdonlan@gmail.com>, Ulrich Drepper <drepper@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
In-Reply-To: <20091103094703.GB11134@hack.redhat.com>
References: <20091101211321.F3FC.A69D9226@jp.fujitsu.com> <20091103094703.GB11134@hack.redhat.com>
Message-Id: <20091103230548.0B45.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >+		case PR_SET_PROCTITLE_AREA: {
> >+			struct mm_struct *mm = current->mm;
> >+			unsigned long addr = arg2;
> >+			unsigned long len = arg3;
> >+			unsigned long end = arg2 + arg3;
> >+
> >+			if (len > PAGE_SIZE)
> >+				return -EINVAL;
> >+
> >+			if (addr >= end)
> >+				return -EINVAL;
> >+
> >+			if (!access_ok(VERIFY_READ, addr, len))
> >+				return -EFAULT;
> >+
> >+			mutex_lock(&mm->arg_lock);
> >+			mm->arg_start = addr;
> 
> Is this safe? You're assigning a user-space pointer to kernel space...
> Don't we need copy_from_user()?

mm->arg_start, arg_end are defined so.
Please see current implementation. 


> >+			mm->arg_end = addr + len;
> 
> Since you already have 'end', no need to caculate this again. :)

Good catch :)


