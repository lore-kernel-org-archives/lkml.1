Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbXK0SyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbXK0SyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 13:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759034AbXK0Sxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 13:53:52 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47761 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758598AbXK0Sxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 13:53:51 -0500
Subject: Re: [Patch](Resend) mm/sparse.c: Improve the error handling for
	sparse_add_one_section()
From: Dave Hansen <haveblue@us.ibm.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@osdl.org>, linux-mm@kvack.org
In-Reply-To: <20071127022609.GA4164@hacking>
References: <1195507022.27759.146.camel@localhost>
	 <20071123055150.GA2488@hacking> <20071126191316.99CF.Y-GOTO@jp.fujitsu.com>
	 <20071127022609.GA4164@hacking>
Content-Type: text/plain
Date: Tue, 27 Nov 2007 10:53:45 -0800
Message-Id: <1196189625.5764.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-27 at 10:26 +0800, WANG Cong wrote:
> 
> @@ -414,7 +418,7 @@ int sparse_add_one_section(struct zone *
>  out:
>         pgdat_resize_unlock(pgdat, &flags);
>         if (ret <= 0)
> -               __kfree_section_memmap(memmap, nr_pages);
> +               kfree(usemap);
>         return ret;
>  }
>  #endif 

Why did you get rid of the memmap free here?  A bad return from
sparse_init_one_section() indicates that we didn't use the memmap, so it
will leak otherwise.

-- Dave

