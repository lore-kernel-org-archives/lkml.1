Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab0BSPeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:34:10 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:55129 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab0BSPeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:34:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qGO3b5nvy63JASyUl0YsW0VnB7bTkwkev5Uo6qD8G++VRl8QRrn/fF2ZNWJusy52lv
         mhP+CTqREydVlr+I2dLBDdAMD1S58vKCj/FVUWLihKvO7sAAv642tAorQ6/4AE4TTbBN
         txgYrLgtHX8jGdbwqICzIoQ5g2qqtjVuKbIok=
MIME-Version: 1.0
In-Reply-To: <20100219084523.GA3525@in.ibm.com>
References: <4B7881AC.5070209@redhat.com>
	 <1266516001-7753-3-git-send-regression-fweisbec@gmail.com>
	 <20100219084523.GA3525@in.ibm.com>
Date: Fri, 19 Feb 2010 16:34:03 +0100
Message-ID: <c62985531002190734j5da1e4bfw54ed4283f4d724e0@mail.gmail.com>
Subject: Re: [PATCH 2/2] hw-breakpoint: Keep track of dr7 local enable bits
From: Frederic Weisbecker <fweisbec@gmail.com>
To: prasad@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Michael Stefaniuc <mstefani@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J . Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Roland McGrath <roland@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/19 K.Prasad <prasad@linux.vnet.ibm.com>:
> So, the thread's copy of DR7 (in thread->ptrace_dr7) stores the
> requested data even if the 'write' onto DR7 i.e. ptrace_write_dr7()
> failed. This can be the other way round i.e. populate the thread's copy
> of DR7 only if the write was successful.



No. We store the new dr7 value only if ptrace_set_dr7() didn't fail.



> I think it will be in consonance with the v2.6.32 behaviour as well. For
> instance, in the code snippet from ptrace_set_debugreg() in v2.6.32
> below:
>                for (i = 0; i < 4; i++)
>                        if ((DR7_MASK >> ((data >> (16 + 4*i)) & 0xf)) & 1)
>                                return -EIO;
>                child->thread.debugreg7 = data;
>
> The thread's copy of DR7 is populated only if the incoming data is
> found to be valid.


This is also what does this patch. thread->ptrace_dr7 is only
changed if ptrace_set_dr7() succeeded.

Thanks.
