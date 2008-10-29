Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbYJ2Q3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbYJ2Q3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 12:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYJ2Q3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 12:29:25 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43349 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbYJ2Q3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 12:29:25 -0400
X-Greylist: delayed 2696 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Oct 2008 12:29:25 EDT
Message-ID: <490884CC.9060106@cs.wisc.edu>
Date: Wed, 29 Oct 2008 10:44:12 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: open-iscsi@googlegroups.com,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: fix uninitialized variable in iscsi
References: <20081029170359.70682e02.sfr@canb.auug.org.au>
In-Reply-To: <20081029170359.70682e02.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> [Resend to get through vger's filters, sorry]
> 
> drivers/scsi/scsi_transport_iscsi.c: In function 'iscsi_add_session':
> drivers/scsi/scsi_transport_iscsi.c:704: warning: 'err' may be used uninitialized in this function
> 
> Indeed the error path can be taken without err being set.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/scsi/scsi_transport_iscsi.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> I don't know if ENOMEM is the proper error code to return.
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 4a803eb..99855db 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -719,6 +719,7 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
>  						 "Too many iscsi targets. Max "
>  						 "number of targets is %d.\n",
>  						 ISCSI_MAX_TARGET - 1);
> +			err = -ENOMEM;
>  			goto release_host;
>  		}
>  	}

Thanks for the patch.

I have a patch for this from Benny Halevy already.
