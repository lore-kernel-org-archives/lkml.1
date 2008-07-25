Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYGYSem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYGYSem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYGYSed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:34:33 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:7017 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbYGYSec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:34:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ottnUQet1cmbbPtxbChOd/obMDi3LGoQSZVNnYBJmlSpZehWLU0T6JJ9oLt9aDGc4W
         ex9yPWZphByx3wYkdjyl441VuIwmwLaBp6nroALhyqxGZ0iCNcdYA7hnVs0Ze3TeJBTx
         BWaPIWb1K89G2QeIZNQP+XIbH+5RiLu8sQpMs=
Message-ID: <488A1CB6.5090707@gmail.com>
Date: Fri, 25 Jul 2008 20:34:30 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
Subject: Re: PAGE_ALIGN() compile breakage
References: <20080725083943.GC19310@cs181140183.pp.htv.fi>	<20080725015537.564e3397.akpm@linux-foundation.org>	<20080725091455.GD19310@cs181140183.pp.htv.fi> <20080725022547.a05ea755.akpm@linux-foundation.org>
In-Reply-To: <20080725022547.a05ea755.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 25 Jul 2008 12:14:55 +0300 Adrian Bunk <bunk@kernel.org> wrote:
> 
>> Ideally, all headers should be self-contained. IOW, they should #include 
>> everything they use.
> 
> Yup.  And the core reason for our headers mess is that the headers do
> too much stuff, and cnosequently demand a large dependency trail.
> 
>> But TASK_UNMAPPED_BASE in asm/processor.h on some architectures uses 
>> PAGE_ALIGN() that got moved from asm/page.h to linux/mm.h .
> 
> Probably mm.h should be split up - put the simple things (usually
> declarations) into one "early" header file and leave the more
> heavyweight things (usually implementations) in mm.h.

IMHO splitting mm.h is probably the best solution. If I'm not wrong
Paul (CCed) already suggested to move the stuff like PAGE_ALIGN() outside
mm.h the first time I submitted this patch.

In this way we could even include the "lightweight" mm.h (mm_define.h??)
in all the asm-*/page.h, preserving also the backward compatibility.

-Andrea
