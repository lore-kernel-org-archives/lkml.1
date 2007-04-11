Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbXDKJxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbXDKJxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbXDKJxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:53:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:15644 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbXDKJxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:53:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Yxfzhz3PejhqdLjMkGb8cQy90Ed/vx5bPaQj/qKhrO7CxlcBJMdxMEfLuHFMy/wr/dr1SeSjoNp9dbPRwBQypAG9v7MpL5B98ANrMa4HOVf7flWVaReX2dxNXzi7HLLclM1eynWH5UMIDgMwGWhyBfOlydoKqQJkmg08hDJOYUk=
Message-ID: <ac8af0be0704110253p74de6197p1df6a5b99585709c@mail.gmail.com>
Date: Wed, 11 Apr 2007 17:53:49 +0800
From: "Zhao Forrest" <forrest.zhao@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: Why kmem_cache_free occupy CPU for more than 10 seconds?
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <84144f020704102353r7dcc3538u2e34237d3496630e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac8af0be0704102317q50fe72b1m9e4825a769a63963@mail.gmail.com>
	 <84144f020704102353r7dcc3538u2e34237d3496630e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I got some new information:
Before soft lockup message is out, we have:
[root@nsgsh-dhcp-149 home]# cat /proc/slabinfo |grep buffer_head
buffer_head       10927942 10942560    120   32    1 : tunables   32
16    8 : slabdata 341955 341955      6 : globalstat 37602996 11589379
1174373    6                              0    1 6918 12166031 1013708
: cpustat 35254590 2350698 13610965 907286

Then after buffer_head is freed, we have:
[root@nsgsh-dhcp-149 home]# cat /proc/slabinfo |grep buffer_head
buffer_head         9542  36384    120   32    1 : tunables   32   16
  8 : slabdata   1137   1137    245 : globalstat 37602996 11589379
1174373    6                                  0    1 6983 20507478
1708818 : cpustat 35254625 2350704 16027174 1068367

Does this huge number of buffer_head cause the soft lockup?

Thanks,
Forrest

On 4/11/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On 4/11/07, Zhao Forrest <forrest.zhao@gmail.com> wrote:
> > We're using RHEL5 with kernel version 2.6.18-8.el5.
> > When doing a stress test on raw device for about 3-4 hours, we found
> > the soft lockup message in dmesg.
> > I know we're not reporting the bug on the latest kernel, but does any
> > expert know if this is the known issue in old kernel? Or why
> > kmem_cache_free occupy CPU for more than 10 seconds?
>
> Sounds like slab corruption. CONFIG_DEBUG_SLAB should tell you more.
>
