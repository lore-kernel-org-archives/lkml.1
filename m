Return-Path: <linux-kernel-owner+w=401wt.eu-S967977AbXEHNxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967977AbXEHNxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967377AbXEHNxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:53:44 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:26487 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967868AbXEHNxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:53:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=OGvr0W5UFVEofvkBLyywKH+evW2w2BGfpk0RI890TrxD/t/NCZ+7naahYWSTysMQHwNCZNVkuyAtjVjz8SxGYaauEcNiZuTRrJWOaP+qEz/dAgyCxMOuZ9kjzrGTAkwG8Wcu+tLqZF02oc0hh+c6vhzn72fl6f3F1wroTBZZfLs=
Message-ID: <84144f020705080653i16d324c8pbd2925d844f400fc@mail.gmail.com>
Date: Tue, 8 May 2007 16:53:41 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: New Mitsumi legacy CD-ROM driver
Cc: "Andrew Morton" <akpm@osdl.org>, "Jens Axboe" <jens.axboe@oracle.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <464045F0.3040906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464045F0.3040906@gmail.com>
X-Google-Sender-Auth: ff3c4e6591b0da15
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rene,

On 5/8/07, Rene Herman <rene.herman@gmail.com> wrote:
> +static int __mitsumi_read_toc(struct mitsumi_cdrom *mcd)
> +{
> +       int tracks = mcd->header.cdth_trk1 - mcd->header.cdth_trk0 + 1;
> +       int retries;
> +       int err = 0;
> +
> +       kfree(mcd->toc);
> +
> +       mcd->toc = kzalloc(tracks * sizeof *mcd->toc, GFP_KERNEL);

Perhaps we should use krealloc() + memset() here?
