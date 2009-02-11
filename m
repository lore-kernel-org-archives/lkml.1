Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbZBKABT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbZBKABT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZBKABI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:01:08 -0500
Received: from smtp-out.google.com ([216.239.33.17]:37559 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZBKABH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:01:07 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=uLv+Z8K78P5mZ55FAR8og0nBW2vcrNgCtixrY8/cTYWLb+WCkwWVrjCvkJ2soKEjs
	cAhKHyxT003M+G+Ca7N5A==
MIME-Version: 1.0
In-Reply-To: <4991497B.4030200@cn.fujitsu.com>
References: <4991497B.4030200@cn.fujitsu.com>
Date: Tue, 10 Feb 2009 16:01:01 -0800
Message-ID: <6599ad830902101601g6098acf7ua25138a5c6c7db92@mail.gmail.com>
Subject: Re: [PATCH] cgroups: fix possible use after free
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 1:31 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> In cgroup_kill_sb(), root is freed before sb is detached from the list,
> so another sget() may find this sb and call cgroup_test_super(),
> which will access the root that has been freed.
>
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Seems like the safest fix.

Paul
