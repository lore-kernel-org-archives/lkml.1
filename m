Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbYCUPlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbYCUPlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 11:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYCUPlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 11:41:45 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:55991 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbYCUPlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 11:41:44 -0400
Date: Fri, 21 Mar 2008 11:41:25 -0400
From: Konrad Rzeszutek <konrad@darnok.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       ketuzsezr@darnok.org
Subject: Re: [mmotm] iscsi_ibft build error
Message-ID: <20080321154125.GA29019@andromeda.dapyr.net>
References: <20080319115655.ff4cb67a.randy.dunlap@oracle.com> <20080320154555.2d74c0d5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320154555.2d74c0d5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 03:45:55PM -0700, Andrew Morton wrote:
> On Wed, 19 Mar 2008 11:56:55 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > mmotm-2008-0318-1720/drivers/firmware/iscsi_ibft.c: In function 'ibft_show_attribute':
> > mmotm-2008-0318-1720/drivers/firmware/iscsi_ibft.c:521: error: implicit declaration of function 'capable'
> > mmotm-2008-0318-1720/drivers/firmware/iscsi_ibft.c:521: error: 'CAP_SYS_ADMIN' undeclared (first use in this function)
> > mmotm-2008-0318-1720/drivers/firmware/iscsi_ibft.c:521: error: (Each undeclared identifier is reported only once
> > mmotm-2008-0318-1720/drivers/firmware/iscsi_ibft.c:521: error: for each function it appears in.)
> > make[3]: *** [drivers/firmware/iscsi_ibft.o] Error 1
> > 
> 
> --- a/drivers/firmware/iscsi_ibft.c~scsi-add-iscsi-ibft-support-fix
> +++ a/drivers/firmware/iscsi_ibft.c
> @@ -65,6 +65,7 @@
>  
>  
>  #include <linux/blkdev.h>
> +#include <linux/capability.h>
>  #include <linux/ctype.h>
>  #include <linux/device.h>
>  #include <linux/err.h>
> 
> should do the trick.
> 
> Does this driver actually need to run capable(CAP_SYS_ADMIN)?  Can we not
> rely upon permissions of the reelvant sysfs file?

I followed what the efivars driver does. The permissions of the
files are secure (as they are in the efivars), so one layer
of protection could be suffice?
