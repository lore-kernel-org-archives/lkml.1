Return-Path: <linux-kernel-owner+w=401wt.eu-S1761378AbXLTMy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761378AbXLTMy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758915AbXLTMyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:54:51 -0500
Received: from ro-out-1112.google.com ([72.14.202.179]:33961 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbXLTMyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:54:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EmowBWiIB7vSs+cbJNoyrU8m5DtIDxwFtGAMiw+s70jBLZtnahIiz4P90qFiuDw+ZncrrLb3H7jwA7d9VJyja2anvJZwQTV3Nqb06BOx7e4Wbm3m7LmbrBkxxSDrOVZ6L/iGEVnFX1h8SUveGCQpLfBt7DUpJGi5eI9Ki66SVlw=
Message-ID: <a44ae5cd0712200454vc8ff0fbo20d0ee216557efac@mail.gmail.com>
Date: Thu, 20 Dec 2007 07:54:48 -0500
From: "Miles Lane" <miles.lane@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: OOPS: 2.6.24-rc5-mm1 -- EIP is at r_show+0x2a/0x70 -- (triggered by "cat /proc/iomem")
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>
In-Reply-To: <5102.1198150640@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0712192040k7480682eoa29f33d70a91c618@mail.gmail.com>
	 <4769F409.6030300@gmail.com> <4769FF37.5060308@gmail.com>
	 <20071219220307.d69c0fde.akpm@linux-foundation.org>
	 <5102.1198150640@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 20, 2007 6:37 AM, David Howells <dhowells@redhat.com> wrote:
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
> > I would be suspecting iget-stop-procfs-from-using-iget-and-read_inode.patch.
>
> I think your suspicions are very unlikely.  The patch only affects
> proc_get_inode() - and looking at the patch backtrace, it looks like the
> system is successfully past that already (it's unlikely that
> proc_reg_read+0x60/0x74 would have been reached otherwise).
>
> If my patch to procfs is wrong, it would affect all proc files and ought be
> immediately detectable.

I tested the patch Andrew sent.  I ran "cat /proc/iomem" before trying
a suspend-to-disk.  It worked fine.  Then I suspended and resumed.
This time, "cat /proc/iomem" caused the stack trace to be generated.
So, you are right, you patch is not the problem.

Thanks,
              Miles
