Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYBXGUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYBXGUS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 01:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbYBXGUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 01:20:05 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:49913 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYBXGUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 01:20:01 -0500
Message-ID: <fa686aa40802232220m175cfd86w1f85e46473371539@mail.gmail.com>
Date: Sat, 23 Feb 2008 23:20:00 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
Subject: Re: [PATCH] Xilinx: hwicap: cleanup
Cc: linuxppc-dev@ozlabs.org, git-dev@xilinx.com, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <fa686aa40802232216s47b7751bi384352697dbf4ce2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202437061-12691-1-git-send-email-stephen.neuendorffer@xilinx.com>
	 <20080211182429.76E204D8018@mail62-sin.bigfish.com>
	 <fa686aa40802232216s47b7751bi384352697dbf4ce2@mail.gmail.com>
X-Google-Sender-Auth: b726eab05d42a2db
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen, when you address these comments, please double check the lkml
address.  It was misspelled when you sent this patch.

Cheers,
g.

On Sat, Feb 23, 2008 at 11:16 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Mon, Feb 11, 2008 at 11:24 AM, Stephen Neuendorffer
>  <stephen.neuendorffer@xilinx.com> wrote:
>  > Fix some missing __user tags and incorrect section tags.
>  >  Convert semaphores to mutexes.
>  >  Make probed_devices re-entrancy and error condition safe.
>  >  Fix some backwards memcpys.
>  >  Some other minor cleanups.
>  >  Use kerneldoc format.
>  >
>  >  Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
>
>  Thanks Steven, some more comments below.
         ^^^^^^

Oops, sorry about the spelling.

g.

>
>
>  >
>  >  ---
>  >
>  >  Grant, Since it appears that the driver will stay in as-is, here are
>  >  the updates against mainline, based on Jiri's comments.
>  >  ---
>  >   drivers/char/xilinx_hwicap/buffer_icap.c   |   80 ++++++++++----------
>  >   drivers/char/xilinx_hwicap/fifo_icap.c     |   60 +++++++-------
>  >   drivers/char/xilinx_hwicap/xilinx_hwicap.c |  113 ++++++++++++++++------------
>  >   drivers/char/xilinx_hwicap/xilinx_hwicap.h |   24 +++---
>  >   4 files changed, 148 insertions(+), 129 deletions(-)
>  >
>  >  diff --git a/drivers/char/xilinx_hwicap/buffer_icap.c b/drivers/char/xilinx_hwicap/buffer_icap.c
>  >  index dfea2bd..2c5d17d 100644
>  >  --- a/drivers/char/xilinx_hwicap/buffer_icap.c
>  >  +++ b/drivers/char/xilinx_hwicap/buffer_icap.c
>
> >  @@ -148,9 +148,9 @@ static inline void buffer_icap_set_size(void __iomem *base_address,
>  >   }
>  >
>  >   /**
>  >  - * buffer_icap_mSetoffsetReg: Set the bram offset register.
>  >  - * @parameter base_address: contains the base address of the device.
>  >  - * @parameter data: is the value to be written to the data register.
>  >  + * buffer_icap_mSetoffsetReg - Set the bram offset register.
>
>  This is the only function that is still in camel case; it should
>  probably be changed also... In fact, this functions doesn't seem to be
>  used at all.  Can it just be removed?  Are there any other unused
>  functions in this driver?
>
>
>  >  diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
>  >  index 24f6aef..eddaa26 100644
>  >  --- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
>  >  +++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
>
> >  @@ -344,7 +345,7 @@ int hwicap_initialize_hwicap(struct hwicap_drvdata *drvdata)
>  >   }
>  >
>  >   static ssize_t
>  >  -hwicap_read(struct file *file, char *buf, size_t count, loff_t *ppos)
>  >  +hwicap_read(struct file *file, __user char *buf, size_t count, loff_t *ppos)
>
>  This looks like it should be 'char __user *buf' instead of '__user char *buf'.
>
>
>  >   {
>  >         struct hwicap_drvdata *drvdata = file->private_data;
>  >         ssize_t bytes_to_read = 0;
>
> >   static ssize_t
>  >  -hwicap_write(struct file *file, const char *buf,
>  >  +hwicap_write(struct file *file, const __user char *buf,
>  >                 size_t count, loff_t *ppos)
>
>  Ditto on placement of __user
>
>
>  >  @@ -549,8 +556,7 @@ static int hwicap_release(struct inode *inode, struct file *file)
>  >         int i;
>  >         int status = 0;
>  >
>  >  -       if (down_interruptible(&drvdata->sem))
>  >  -               return -ERESTARTSYS;
>  >  +       mutex_lock(&drvdata->sem);
>
>  Why not mutex_lock_interruptible()? (goes for all cases of mutex_lock())
>
>  Cheers,
>  g.
>
>  --
>  Grant Likely, B.Sc., P.Eng.
>  Secret Lab Technologies Ltd.
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
