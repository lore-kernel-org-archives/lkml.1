Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbYIDRuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbYIDRuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 13:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755996AbYIDRt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 13:49:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:37849 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbYIDRt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 13:49:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=LIlxfUgxpmxKiBVs/ifgn8WrldtFypmgBO6iZstdlR/iBnclm/KekTxunoGSu8Fw4
	pLabG/ubBC5Br+dUGD86A==
Message-ID: <6599ad830809041049i646c9e43gb276090dc76ab1a7@mail.gmail.com>
Date: Thu, 4 Sep 2008 10:49:09 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cpuset: avoid changing cpuset's cpus when -errno returned
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Paul Jackson" <pj@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48BE3DE1.6030801@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48BE3DE1.6030801@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2008 at 12:33 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> After the patch:
>
> commit 0b2f630a28d53b5a2082a5275bc3334b10373508
> Author: Miao Xie <miaox@cn.fujitsu.com>
> Date:   Fri Jul 25 01:47:21 2008 -0700
>
>    cpusets: restructure the function update_cpumask() and update_nodemask()
>
> It might happen that 'echo 0 > /cpuset/sub/cpus' returns failure but 'cpus'
> has been changed, because cpus was changed before calling heap_init() which
> may return -ENOMEM.

Since neither of the callers of update_tasks_cpumask() check the
return value (one knows it's going to be 0, the other doesn't care
about errors) I think it would be better to just make it a void
function.

Paul
