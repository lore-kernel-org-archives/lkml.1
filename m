Return-Path: <linux-kernel-owner+w=401wt.eu-S1752485AbZHTDEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbZHTDEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 23:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbZHTDEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 23:04:31 -0400
Received: from smtp-out.google.com ([216.239.45.13]:17284 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbZHTDEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 23:04:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=up+WgIAuTDMWjE+p6PxwhZlCBHBGrzWyDA29CRCX2Od6sr/RHl/p3ZT0cwjuxBq3K
	IUwviajS85NVP8s78YLpQ==
MIME-Version: 1.0
In-Reply-To: <4A8CBAE1.9010408@cn.fujitsu.com>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
	 <20090818235827.22531.60306.stgit@menage.mtv.corp.google.com>
	 <4A8CB6F0.1020308@cn.fujitsu.com>
	 <6599ad830908191941g77db4e69ve46bc8623f77d97f@mail.gmail.com>
	 <4A8CBAE1.9010408@cn.fujitsu.com>
Date: Wed, 19 Aug 2009 20:04:28 -0700
Message-ID: <6599ad830908192004k5ea7b7a8y575d403113f126a8@mail.gmail.com>
Subject: Re: [PATCH 4/8] Use vmalloc for large cgroups pidlist allocations
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, bblum@andrew.cmu.edu,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 7:54 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>
> To avoid showing duplicate threadgroup pids, when dealing with a
> thread, you have to check backwards to see if it's group pid
> has been printed. Maybe it doesn't add much extra cost with your
> proposal, we'll see.

My thought was to explicitly specify the output of cgroup.procs as
"mostly unique" and leave it up to userspace to make it really unique
if necessary. Then we can just skip the tgid if it's the same as the
previous one, and that will give you a unique list in the common case.

Paul
