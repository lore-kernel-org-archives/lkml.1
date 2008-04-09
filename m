Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbYDIPxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbYDIPxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 11:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbYDIPxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 11:53:41 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:40496 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbYDIPxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M281hXwug9epy70zHgj7E7GBaLgPlXQJcitKXOVbnhAyV7ujj5Fk83f4d4r6E/BwgoLFgcpy3v/zUThV91NIoWDXbd+3GVuCiXtqef767FUrPcHbti9qPoEQ77/8l+2arznRvRp5y/2ipa0loUobFMHf3hbHiex+TxhCeTcDHCk=
Message-ID: <36ca99e90804090853xf62438ayfbfa6010f2d31747@mail.gmail.com>
Date: Wed, 9 Apr 2008 17:53:38 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 2/3] cpumask: use new cpus_scnprintf function v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Paul Jackson" <pj@sgi.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <47FBD99A.2080007@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	 <20080408184301.975491000@polaris-admin.engr.sgi.com>
	 <36ca99e90804081240q31516fbegadbcc98360813863@mail.gmail.com>
	 <47FBD99A.2080007@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 10:46 PM, Mike Travis <travis@sgi.com> wrote:
>
> Bert Wesarg wrote:
>  > On Tue, Apr 8, 2008 at 8:43 PM, Mike Travis <travis@sgi.com> wrote:
>  >>  --- linux-2.6.x86.sched.orig/drivers/base/node.c
>  >>  +++ linux-2.6.x86.sched/drivers/base/node.c
>  >>  @@ -19,22 +19,34 @@ static struct sysdev_class node_class =
>  >>   };
>  >>
>  >>
>  >>  -static ssize_t node_read_cpumap(struct sys_device * dev, char * buf)
>  >>  +static ssize_t node_read_cpumap(struct sys_device *dev, int type, char *buf)
>  >>   {
>  >>         struct node *node_dev = to_node(dev);
>  >>         node_to_cpumask_ptr(mask, node_dev->sysdev.id);
>  >>         int len;
>  >>
>  >>  -       /* 2004/06/03: buf currently PAGE_SIZE, need > 1 char per 4 bits. */
>  >>  -       BUILD_BUG_ON(MAX_NUMNODES/4 > PAGE_SIZE/2);
>  >>  +       /* 2008/04/07: buf currently PAGE_SIZE, need 9 chars per 32 bits. */
>  >>  +       BUILD_BUG_ON((NR_CPUS/32 * 9) > (PAGE_SIZE-1));
>  > Is this right, that you switch from MAX_NUMNODES to NR_CPUS?
>  >
>  > Regards
>  > Bert
>
>  It's printing the number of cpus on a node, so the number of nodes is not
>  important, it's how many cpus can fit on the head of a node... ;-)
Ahh, the old code was Just Plain Wrong.

Thanks.
Bert
>
>  Thanks,
>  Mike
>
