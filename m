Return-Path: <linux-kernel-owner+w=401wt.eu-S934086AbZLGLkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086AbZLGLkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 06:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932800AbZLGLkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 06:40:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932559AbZLGLkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 06:40:17 -0500
Message-ID: <4B1CEA16.2040702@redhat.com>
Date: Mon, 07 Dec 2009 19:42:14 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [Patch] proc: fill 'lib' field in /proc/<pid>/statm
References: <20091207102808.4312.38760.sendpatchset@localhost.localdomain> <Pine.LNX.4.64.0912071101530.29718@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0912071101530.29718@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Mon, 7 Dec 2009, Amerigo Wang wrote:
> 
>> Currently, the 'lib' field of /proc/<pid>/statm is
>> always 0, we should fill it with the right value,
>> the same with 'VmLib'.
> 
> The right value (if you're looking for consistency with Linux 2.4)
> is the number of currently resident "library" pages: and we don't
> know that number - we can't even define what a library is.

Hmm, the current algorithm is just kicking out text size of itself
from ->exec_vm, it really makes some sense, but not always.

> 
> We could add some code to make it show the same bogus number as
> we show somewhere else, but it has said 0 ever since 2.5.37: so
> I don't think it's worth a line of code myself, but bow to others.


If you mean 'VmLib' in /proc/<pid>/status, this is the same with it.

> 
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: Eric W. Biederman <ebiederm@xmission.com>
>> Cc: Alexey Dobriyan <adobriyan@gmail.com>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> Cc: Mel Gorman <mel@csn.ul.ie>
>> Cc: stable@kernel.org
> 
> What does alarm me is that you think this is fit for -stable!
> 

Oh, sorry, I thought missing this field is a mistake...
Dropped.

Thanks.
