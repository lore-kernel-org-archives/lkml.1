Return-Path: <linux-kernel-owner+w=401wt.eu-S932901AbZHUXhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbZHUXhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 19:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbZHUXhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 19:37:47 -0400
Received: from smtp-out.google.com ([216.239.45.13]:48788 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbZHUXhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 19:37:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=IcDPMjGjHZBt+xYczBoNn4uoN1cGo+ebyO8fWhTq24WzvVE+5FVG4+TyO70Ay5i/E
	QukBCQ4x+II5Dj5V5MODg==
MIME-Version: 1.0
In-Reply-To: <20090821104528.GA3487@redhat.com>
References: <200908202114.n7KLEN5H026646@imap1.linux-foundation.org>
	 <20090821102611.GA2611@redhat.com> <20090821104528.GA3487@redhat.com>
Date: Fri, 21 Aug 2009 16:37:44 -0700
Message-ID: <6599ad830908211637w6c9fd3a7tbe41bc106ada03d7@mail.gmail.com>
Subject: Re: + cgroups-add-functionality-to-read-write-lock-clone_thread-forking-pe 
	r-threadgroup.patch added to -mm tree
From: Paul Menage <menage@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, bblum@google.com,
       ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 3:45 AM, Oleg Nesterov<oleg@redhat.com> wrote:
> In case I wasn't clear.
>
> Let's suppose we have subthreads T1 and T2, and we have a reference to T1.

In this case, T1 is also the thread group leader.

And we hold tasklist_lock around the entire operation. (So the
rcu_read_lock() call is probably a red herring - Li Zefan already
suggested that it be removed).

But you're saying that could still be a problem if tsk exits  before
we even get to this point?

My impression was that if the thread group leader exits, it hangs
around (still attached to its thread group list) until all its threads
have exited. In which case as long as we're holding tasklist_lock, the
thread group list should remain valid.

Paul
