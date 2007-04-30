Return-Path: <linux-kernel-owner+w=401wt.eu-S1946520AbXD3RJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946520AbXD3RJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946519AbXD3RJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:09:57 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49743 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946520AbXD3RJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:09:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=NIWV+5H8/vcRqfkMAUPbX12m8XkxkBrdtEvV6ojhJJgX5ZKloAIw7n9iIvT91bliV
	q6v+9OugVsI43mRfA9zWA==
Message-ID: <6599ad830704301009k11100a78we98e20deba9b1fdc@mail.gmail.com>
Date: Mon, 30 Apr 2007 10:09:38 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com, "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH 0/9] Containers (V9): Generic Process Containers
Cc: akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       ebiederm@xmission.com, haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com,
       balbir@in.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, rohitseth@google.com, mbligh@google.com,
       containers@lists.osdl.org, devel@openvz.org
In-Reply-To: <20070430171225.GH24350@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070427104607.252541000@menage.corp.google.com>
	 <20070429023721.53f249b9.pj@sgi.com>
	 <20070430171225.GH24350@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> On Sun, Apr 29, 2007 at 02:37:21AM -0700, Paul Jackson wrote:
> > It builds and boots and mounts the cpuset file system ok.
> > But trying to write the 'mems' file hangs the system hard.
>
> Basically we are attempting a read_lock(&tasklist_lock) in
> container_task_count() after taking write_lock_irq(&tasklist_lock) in
> update_nodemask()!

Paul, is there any reason why we need to do a write_lock() on
tasklist_lock if we're just trying to block fork, or is it just
historical accident? Wouldn't it be fine to do a read_lock()?

Paul
