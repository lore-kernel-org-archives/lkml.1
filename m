Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbYKDGhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbYKDGhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYKDGhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:37:41 -0500
Received: from smtp-out.google.com ([216.239.33.17]:34454 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbYKDGhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:37:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=yFgdqXfcd52hvi54LQ5Bvd7dJqeRD57bJLdxjLWdPrx7bZMS6EhAveafkuxNSsXfb
	8eJzN+jKz4o7piaHeZ13A==
MIME-Version: 1.0
In-Reply-To: <490DCCC9.5000508@linux.vnet.ibm.com>
References: <20081101184812.2575.68112.sendpatchset@balbir-laptop>
	 <20081101184902.2575.11443.sendpatchset@balbir-laptop>
	 <20081102143817.99edca6d.kamezawa.hiroyu@jp.fujitsu.com>
	 <490D42C7.4000301@linux.vnet.ibm.com>
	 <20081102152412.2af29a1b.kamezawa.hiroyu@jp.fujitsu.com>
	 <490DCCC9.5000508@linux.vnet.ibm.com>
Date: Mon, 3 Nov 2008 22:37:31 -0800
Message-ID: <6599ad830811032237q14c065efx4316fee8f8daa515@mail.gmail.com>
Subject: Re: [mm] [PATCH 4/4] Memory cgroup hierarchy feature selector
From: Paul Menage <menage@google.com>
To: balbir@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 2, 2008 at 7:52 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> That should not be hard, but having it per-subtree sounds a little complex in
> terms of exploiting from the end-user perspective and from symmetry perspective
> (the CPU cgroup controller provides hierarchy control for the full hierarchy).
>

The difference is that the CPU controller works in terms of shares,
whereas memory works in terms of absolute memory size. So it pretty
much has to limit the hierarchy to a single tree. Also, I didn't think
that you could modify the shares for the root cgroup - what would that
mean if so?

With this patch set as it is now, the root cgroup's lock becomes a
global memory allocation/deallocation lock, which seems a bit painful.
Having a bunch of top-level cgroups each with their own independent
memory limits, and allowing sub cgroups of them to be constrained by
the parent's memory limit, seems more useful than a single hierarchy
connected at the root.

In what realistic circumstances do you actually want to limit the root
cgroup's memory usage?

Paul
