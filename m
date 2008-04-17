Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbYDQFU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbYDQFU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 01:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYDQFUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 01:20:51 -0400
Received: from smtp-out.google.com ([216.239.33.17]:43942 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbYDQFUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 01:20:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=kdxPFpqILPNfwHIxFWupWQ+1tKtQ56Z8oEC/yHHSb2gGWFvLNcOTXh3zK+sd6jVs/
	XJdzgy3Kp6Qfeja9lSGkA==
Message-ID: <6599ad830804162220v51dc861ah73938941758810e5@mail.gmail.com>
Date: Wed, 16 Apr 2008 22:20:44 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] cgroup: fix a race condition in manipulating tsk->cg_list
Cc: "Li Zefan" <lizf@cn.fujitsu.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Paul Jackson" <pj@sgi.com>
In-Reply-To: <20080416215907.63d71409.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4806C5EB.3040102@cn.fujitsu.com>
	 <20080416211144.a38f6fc0.akpm@linux-foundation.org>
	 <6599ad830804162117w14364b7cg20d3694ffdfeb867@mail.gmail.com>
	 <20080416215907.63d71409.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 9:59 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  >
>  > Task A starts exiting, passes the check for unlinking current->cg_list.
>
>  So cgroup_exit() sees !list_empty(tsk->cg_list)

We don't actually set up the links running through tsk->cg_list to the
css_set objects until the first time someone calls cgroup_iter_begin()
- so anyone who never actually uses cgroups doesn't pay the list
management overhead. So in this case, the list is empty.

Paul
