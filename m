Return-Path: <linux-kernel-owner+w=401wt.eu-S932111AbXJOXfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbXJOXfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761663AbXJOXfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:35:37 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:54257 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761425AbXJOXfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:35:36 -0400
Subject: Re: [PATCH] git scsi misc include fix
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Paul Jackson <pj@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <20071014053508.30836.69658.sendpatchset@jackhammer.engr.sgi.com>
References: <20071014053508.30836.69658.sendpatchset@jackhammer.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 19:35:30 -0400
Message-Id: <1192491330.14524.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-13 at 22:35 -0700, Paul Jackson wrote:
> From: Paul Jackson <pj@sgi.com>
> 
> The added line in scsi_eh.h:
> 	struct scatterlist sense_sgl;
> fails to compile, with the error:
> 	field 'sense_sgl' has incomplete type
> unless scatterlist.h happens to be included
> somehow already ... which it isn't always.
> 
> So include scatterlist.h in scsi_eh.h directly.
> 
> Signed-off-by: Paul Jackson <pj@sgi.com>
> 
> ---
> 
> This patch goes after the patch 'git-scsi-misc.patch'
> 
>  include/scsi/scsi_eh.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- 2.6.23-mm1.orig/include/scsi/scsi_eh.h	2007-10-13 01:13:26.568876534 -0700
> +++ 2.6.23-mm1/include/scsi/scsi_eh.h	2007-10-13 01:31:32.911855338 -0700
> @@ -2,6 +2,7 @@
>  #define _SCSI_SCSI_EH_H
>  
>  #include <scsi/scsi_cmnd.h>
> +#include <linux/scatterlist.h>
>  struct scsi_device;
>  struct Scsi_Host;


I've added linux-scsi which should be cc'd on all SCSI issues.

I don't quite believe this, though.  The requirement for struct
scatterlist is the same before and after the gid scsi-misc patch.  If
the compile fails with git-scsi-misc because of a missing scatterlist
include, it should also fail with vanilla 2.6.23 without the git
patch ... could you see if you can find out why it doesn't?

thanks,

James


