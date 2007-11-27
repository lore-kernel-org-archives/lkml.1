Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbXK0ME1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbXK0ME1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 07:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbXK0MET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 07:04:19 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41318 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbXK0MES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 07:04:18 -0500
Date: Tue, 27 Nov 2007 20:55:30 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [Patch](Resend) mm/sparse.c: Improve the error handling for sparse_add_one_section()
Cc: Dave Hansen <haveblue@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@osdl.org>, linux-mm@kvack.org
In-Reply-To: <20071127022609.GA4164@hacking>
References: <20071126191316.99CF.Y-GOTO@jp.fujitsu.com> <20071127022609.GA4164@hacking>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071127204623.3D53.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  	ret = sparse_init_one_section(ms, section_nr, memmap, usemap);
> @@ -414,7 +418,7 @@ int sparse_add_one_section(struct zone *
>  out:
>  	pgdat_resize_unlock(pgdat, &flags);
>  	if (ret <= 0)
> -		__kfree_section_memmap(memmap, nr_pages);
> +		kfree(usemap);
>  	return ret;
>  }
>  #endif
> 

I guess you think __kfree_section_memmap() is not necessary due to
no implementation. But, it is still available when
CONFIG_SPARSEMEM_VMEMMAP is off. So, it should not be removed.


Bye.

-- 
Yasunori Goto 


