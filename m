Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbZG1Vts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbZG1Vts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZG1Vtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:49:47 -0400
Received: from smtp-out.google.com ([216.239.45.13]:6622 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbZG1Vtq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:49:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=v28x2tUyaekrn9R6ax6qXvquaMaMGeLi0mrHvuYk1DrX0BmUyYJITiRmkxXGt2u4i
	/CygfNo/MR/C4OUf7s0Lw==
MIME-Version: 1.0
In-Reply-To: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com>
Date: Tue, 28 Jul 2009 14:49:38 -0700
Message-ID: <33307c790907281449k5e8d4f6cib2c93848f5ec2661@mail.gmail.com>
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
From: Martin Bligh <mbligh@google.com>
To: Chad Talbott <ctalbott@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, wfg@mail.ustc.edu.cn,
       Michael Rubin <mrubin@google.com>, Andrew Morton <akpm@google.com>,
       sandeen@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> An interesting recent-ish change is "writeback: speed up writeback of
> big dirty files."  When I revert the change to __sync_single_inode the
> problem appears to go away and background writeout proceeds at disk
> speed.  Interestingly, that code is in the git commit [2], but not in
> the post to LKML. [3]  This is may not be the fix, but it makes this
> test behave better.

I'm fairly sure this is not fixing the root cause - but putting it at the head
rather than the tail of the queue causes the error not to starve wb_kupdate
for nearly so long - as long as we keep the queue full, the bug is hidden.

M.
