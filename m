Return-Path: <linux-kernel-owner+w=401wt.eu-S1762715AbZE0O2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762715AbZE0O2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 10:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760817AbZE0O20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 10:28:26 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59073 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996AbZE0O2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 10:28:25 -0400
Message-ID: <4A1D4DBA.8050802@cs.wisc.edu>
Date: Wed, 27 May 2009 09:27:06 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] [SCSI]: scsi_transport_iscsi.c return -EOVERFLOW
 for Too many iscsi targets
References: <1243401279.3118.2.camel@localhost.localdomain>
In-Reply-To: <1243401279.3118.2.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> setting err as -EOVERFLOW for Too many iscsi targets.
> 
> Also fixes compiler warning for gcc < 4.3.3 :
> 
>   CC      drivers/scsi/scsi_transport_iscsi.o
> drivers/scsi/scsi_transport_iscsi.c: In function ‘iscsi_add_session’:
> drivers/scsi/scsi_transport_iscsi.c:678: warning: ‘err’ may be used uninitialized in this function
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 0947954..fdcda7f 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -693,6 +693,7 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
>  						 "Too many iscsi targets. Max "
>  						 "number of targets is %d.\n",
>  						 ISCSI_MAX_TARGET - 1);
> +			err = -EOVERFLOW;
>  			goto release_host;
>  		}
>  	}


Fine by me. Send it through whatever tree you guys want.

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
