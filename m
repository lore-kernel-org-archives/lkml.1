Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYLSOHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYLSOHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 09:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbYLSOGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 09:06:52 -0500
Received: from smtp-out.google.com ([216.239.45.13]:57861 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbYLSOGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 09:06:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:content-transfer-encoding;
	b=WhJgBKIUOb7CYCVtR7CPGWdb/JFsv26S2JLO2CTF8TkddnHeaROHQoreSFZfq1v3c
	xMdl04R9Kd1w65mHhvkBQ==
MIME-Version: 1.0
In-Reply-To: <20081219043702.GA5453@balbir.in.ibm.com>
References: <494234B0.5@cn.fujitsu.com> <20081212100044.GB18152@elte.hu>
	 <4944754F.8050503@cn.fujitsu.com>
	 <1229258890.17130.9.camel@lappy.programming.kicks-ass.net>
	 <20081219043702.GA5453@balbir.in.ibm.com>
Date: Fri, 19 Dec 2008 06:06:46 -0800
Message-ID: <6599ad830812190606n6c6cc70ew320b7722785d9345@mail.gmail.com>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
From: Paul Menage <menage@google.com>
To: balbir@linux.vnet.ibm.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 8:37 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>
>> Can't we detect a dead task-group and skip those instead of adding this
>> global lock?
>>
>
> Now we can, there is a css_is_removed() function.
>

With the patch that makes cgroup_path() RCU-safe, you shouldn't need
to do any additional skipping or locking.

Paul
