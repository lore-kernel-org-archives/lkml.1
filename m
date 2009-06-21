Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbZFUQhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbZFUQhG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 12:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZFUQg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 12:36:56 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37624 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbZFUQgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 12:36:55 -0400
Message-ID: <4A3E614A.2020300@cs.wisc.edu>
Date: Sun, 21 Jun 2009 11:35:22 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [SCSI RESEND] scsi_transport_iscsi.c return -EOVERFLOW for Too
 many iscsi targets
References: <1243401279.3118.2.camel@localhost.localdomain> <1245484761.3102.11.camel@localhost.localdomain>
In-Reply-To: <1245484761.3102.11.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2009 02:59 AM, Jaswinder Singh Rajput wrote:
> setting err as -EOVERFLOW for Too many iscsi targets.
>
> Also fixes compiler warning for gcc 4.3.3 and gcc 4.4 :
>
>    CC      drivers/scsi/scsi_transport_iscsi.o
> drivers/scsi/scsi_transport_iscsi.c: In function ‘iscsi_add_session’:
> drivers/scsi/scsi_transport_iscsi.c:678: warning: ‘err’ may be used uninitialized in this function
>
> Signed-off-by: Jaswinder Singh Rajput<jaswinderrajput@gmail.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 0947954..fdcda7f 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -693,6 +693,7 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
>   						 "Too many iscsi targets. Max "
>   						 "number of targets is %d.\n",
>   						 ISCSI_MAX_TARGET - 1);
> +			err = -EOVERFLOW;
>   			goto release_host;
>   		}
>   	}


Acked-by: Mike Christie <michaelc@cs.wisc.edu>
