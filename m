Return-Path: <linux-kernel-owner+w=401wt.eu-S1751010AbXDHKTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010AbXDHKTU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 06:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbXDHKTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 06:19:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53543 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbXDHKTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 06:19:04 -0400
Date: Sun, 8 Apr 2007 11:19:02 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Cameron <smcameron@yahoo.com>
Cc: linux-kernel@vger.kernel.org, james.bottomley@steeleye.com,
       mike.miller@hp.com, steve.cameron@hp.com
Subject: Re: [PATCH] Perverting cciss
Message-ID: <20070408101902.GA2275@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Stephen Cameron <smcameron@yahoo.com>, linux-kernel@vger.kernel.org,
	james.bottomley@steeleye.com, mike.miller@hp.com,
	steve.cameron@hp.com
References: <438450.66991.qm@web33002.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <438450.66991.qm@web33002.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 10:07:52AM -0700, Stephen Cameron wrote:
> How about something like this:
> (Since my mailer is sure to wreck the patch, it can be found intact here:
> http://cciss.cvs.sourceforge.net/*checkout*/cciss/patches/kernel.org-2.6/cciss_sg_io_block_pc.patch?revision=1.1

Looks good except for some codingstyle nits:

> @@ -45,7 +45,7 @@
>  #include <linux/blkdev.h>
>  #include <linux/genhd.h>
>  #include <linux/completion.h>
> -
> +#include <scsi/sg.h>

Please don't remove the empty line after the include statements.

> +	case SG_IO: return scsi_cmd_ioctl(filep, disk, cmd, argp);

should be split into two lines for readability.

Also is there a reason you don't want to pass down the various
other ioctls scsi_cmd_ioctl can handle to it?

> +				if (blk_pc_request(cmd->rq)) {
> +					if (cmd->rq->sense) {
> +						if (cmd->rq->sense_len > cmd->err_info->SenseLen)
> +							cmd->rq->sense_len = cmd->err_info->SenseLen;
> +						memcpy(cmd->rq->sense, cmd->err_info->SenseInfo, cmd->rq->sense_len);
> +					} else
> +						cmd->rq->sense_len = 0;
> +				}

Please add some linebreaks so that lines don't grow longer than 80
characters.

