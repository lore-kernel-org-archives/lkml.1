Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbXJ3IHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbXJ3IHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 04:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbXJ3IHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 04:07:11 -0400
Received: from brick.kernel.dk ([87.55.233.238]:23831 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbXJ3IHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 04:07:10 -0400
Date: Tue, 30 Oct 2007 09:04:39 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] Update zfcp_sg_to_address() for new SG chanegs.
Message-ID: <20071030080439.GD4993@kernel.dk>
References: <20071030035138.GV24243@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030035138.GV24243@bakeyournoodle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30 2007, Tony Breeds wrote:
> Commit 642f149031d70415d9318b919d50b71e4724adbd Added args to
> zfcp_sg_to_address() but didn't update the defn. to know about them.
> 
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> ---
> 
> Only compile tested.
> 
>  drivers/s390/scsi/zfcp_def.h |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
> index 0754542..e70cd95 100644
> --- a/drivers/s390/scsi/zfcp_def.h
> +++ b/drivers/s390/scsi/zfcp_def.h
> @@ -70,11 +70,12 @@ zfcp_sg_to_address(struct scatterlist *list)
>   * zfcp_address_to_sg - set up struct scatterlist from kernel address
>   * @address: kernel address
>   * @list: struct scatterlist
> + * @len: buffer length
>   */
>  static inline void
> -zfcp_address_to_sg(void *address, struct scatterlist *list)
> +zfcp_address_to_sg(void *address, struct scatterlist *list, unsigned int len)
>  {
> -	sg_set_buf(list, address, 0);
> +	sg_set_buf(list, address, len);
>  }
>  
>  #define REQUEST_LIST_SIZE 128

Patch for that was merged yesterday.

-- 
Jens Axboe

