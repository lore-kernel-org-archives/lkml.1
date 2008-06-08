Return-Path: <linux-kernel-owner+w=401wt.eu-S1764720AbYFHLXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764720AbYFHLXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758617AbYFHLW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:22:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:32509 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758605AbYFHLWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:22:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=myuSXjV6QYyUwPRWHTx+teP5PtM2/psZUTq+giLiDZ/y67ghCd+dKaRfd1uT4fKtuf
         +rsjfqe9WKow1aftTrx2/plALT70RmGTVcIgbhruta89SDjiNGpwXeqFAi9HOolDe2a2
         74DdvrYOW9Sg1WlHZ0GnaZfm3ZTpED03cKcRc=
Date: Sun, 8 Jun 2008 15:18:42 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: RuoMu Hu <huruomu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Create proc entry under /proc/sys/kernel
Message-ID: <20080608111842.GA12240@martell.zuzino.mipt.ru>
References: <484B91B9.5060204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484B91B9.5060204@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 04:00:57PM +0800, RuoMu Hu wrote:
> Is it possible to create a proc entry under /proc/sys/kernel directly by 
> create_proc_read_entry in the way shown below?

No longer.

> test_pde = create_proc_read_entry("/proc/sys/kernel/test", 0, NULL,
>                                    test_read_proc, NULL);
> if (test_pde == NULL) {
>    printk(KERN_ERR "Failed to create the test proc file.\n");
>    return -ENOMEM;
> }
>
> I'm using this in my kernel module but create_proc_read_entry always 
> returns fail, while there's no problem creating proc entries directly under 
> /proc.  The kernel source I'm building my kernel module against is 
> 2.6.25.4.

Use register_sysctl_table() for sysctls.

