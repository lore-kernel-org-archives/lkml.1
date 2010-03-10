Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab0CJEqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 23:46:32 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:61776 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab0CJEqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 23:46:30 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 9 Mar 2010 21:46:10 -0700
X-Google-Sender-Auth: 8cbe1ba7a5083c03
Message-ID: <fa686aa41003092046m725c8376x64958366b715187@mail.gmail.com>
Subject: Re: [PATCH] Macintosh: fix brace and trailing statement coding style 
	issues in adb-iop.c This is a patch to the adb-iop.c file that cleans up 
	brace and trailing statement warnings found by the checkpatch.pl tool. 
	Signed-off-by: Michael Beardsworth <m
To: Michael Beardsworth <mbeards2@uoregon.edu>
Cc: benh@kernel.crashing.or, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Michael Beardsworth <mbeards@mbeards-mbp.lulzzzzzzz.info>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

Thanks for the patch.  However, whitespace changes like this usually
aren't worth bothering with.  Yeah, sure, they are technically
violations to the coding style, but they aren't egregious and aren't a
serious impediment to readability.  In general I don't want to see
purely minor coding style cleanup patches unless they are part of a
larger effort to tighten up and fix bugs in a driver.  Otherwise it is
just churn for little or no return on effort.

A good place to go looking for really bad code that needs cleaning
effort is in the staging/ directory.

Cheers,
g.

On Tue, Mar 9, 2010 at 2:46 PM, Michael Beardsworth
<mbeards2@uoregon.edu> wrote:
> From: Michael Beardsworth <mbeards@mbeards-mbp.lulzzzzzzz.info>
>
> ---
>  drivers/macintosh/adb-iop.c |   41 +++++++++++++++++++++++------------------
>  1 files changed, 23 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/macintosh/adb-iop.c b/drivers/macintosh/adb-iop.c
> index 4446966..e813589 100644
> --- a/drivers/macintosh/adb-iop.c
> +++ b/drivers/macintosh/adb-iop.c
> @@ -19,13 +19,13 @@
>  #include <linux/init.h>
>  #include <linux/proc_fs.h>
>
> -#include <asm/macintosh.h>
> -#include <asm/macints.h>
> +#include <asm/macintosh.h>
> +#include <asm/macints.h>
>  #include <asm/mac_iop.h>
>  #include <asm/mac_oss.h>
>  #include <asm/adb_iop.h>
>
> -#include <linux/adb.h>
> +#include <linux/adb.h>
>
>  /*#define DEBUG_ADB_IOP*/
>
> @@ -67,7 +67,8 @@ static void adb_iop_end_req(struct adb_request *req, int state)
>  {
>        req->complete = 1;
>        current_req = req->next;
> -       if (req->done) (*req->done)(req);
> +       if (req->done)
> +               (*req->done)(req);
>        adb_iop_state = state;
>  }
>
> @@ -85,9 +86,8 @@ static void adb_iop_complete(struct iop_msg *msg)
>        local_irq_save(flags);
>
>        req = current_req;
> -       if ((adb_iop_state == sending) && req && req->reply_expected) {
> +       if ((adb_iop_state == sending) && req && req->reply_expected)
>                adb_iop_state = awaiting_reply;
> -       }
>
>        local_irq_restore(flags);
>  }
> @@ -113,8 +113,8 @@ static void adb_iop_listen(struct iop_msg *msg)
>        req = current_req;
>
>  #ifdef DEBUG_ADB_IOP
> -       printk("adb_iop_listen %p: rcvd packet, %d bytes: %02X %02X", req,
> -               (uint) amsg->count + 2, (uint) amsg->flags, (uint) amsg->cmd);
> +       printk(KERN_WARNING "adb_iop_listen %p: rcvd packet, %d bytes: %02X %02X",
> +               req, (uint) amsg->count + 2, (uint) amsg->flags, (uint) amsg->cmd);
>        for (i = 0; i < amsg->count; i++)
>                printk(" %02X", (uint) amsg->data[i]);
>        printk("\n");
> @@ -130,9 +130,8 @@ static void adb_iop_listen(struct iop_msg *msg)
>                msg->reply[0] = ADB_IOP_TIMEOUT | ADB_IOP_AUTOPOLL;
>                msg->reply[1] = 0;
>                msg->reply[2] = 0;
> -               if (req && (adb_iop_state != idle)) {
> +               if (req && (adb_iop_state != idle))
>                        adb_iop_end_req(req, idle);
> -               }
>        } else {
>                /* TODO: is it possible for more than one chunk of data  */
>                /*       to arrive before the timeout? If so we need to */
> @@ -169,12 +168,13 @@ static void adb_iop_start(void)
>
>        /* get the packet to send */
>        req = current_req;
> -       if (!req) return;
> +       if (!req)
> +               return;
>
>        local_irq_save(flags);
>
>  #ifdef DEBUG_ADB_IOP
> -       printk("adb_iop_start %p: sending packet, %d bytes:", req, req->nbytes);
> +       printk(KERN_WARNING "adb_iop_start %p: sending packet, %d bytes:", req, req->nbytes);
>        for (i = 0 ; i < req->nbytes ; i++)
>                printk(" %02X", (uint) req->data[i]);
>        printk("\n");
> @@ -203,13 +203,14 @@ static void adb_iop_start(void)
>
>  int adb_iop_probe(void)
>  {
> -       if (!iop_ism_present) return -ENODEV;
> +       if (!iop_ism_present)
> +               return -ENODEV;
>        return 0;
>  }
>
>  int adb_iop_init(void)
>  {
> -       printk("adb: IOP ISM driver v0.4 for Unified ADB.\n");
> +       printk(KERN_MESSAGE "adb: IOP ISM driver v0.4 for Unified ADB.\n");
>        iop_listen(ADB_IOP, ADB_CHAN, adb_iop_listen, "ADB");
>        return 0;
>  }
> @@ -219,10 +220,12 @@ int adb_iop_send_request(struct adb_request *req, int sync)
>        int err;
>
>        err = adb_iop_write(req);
> -       if (err) return err;
> +       if (err)
> +               return err;
>
>        if (sync) {
> -               while (!req->complete) adb_iop_poll();
> +               while (!req->complete)
> +                       adb_iop_poll();
>        }
>        return 0;
>  }
> @@ -252,7 +255,8 @@ static int adb_iop_write(struct adb_request *req)
>        }
>
>        local_irq_restore(flags);
> -       if (adb_iop_state == idle) adb_iop_start();
> +       if (adb_iop_state == idle)
> +               adb_iop_start();
>        return 0;
>  }
>
> @@ -264,7 +268,8 @@ int adb_iop_autopoll(int devs)
>
>  void adb_iop_poll(void)
>  {
> -       if (adb_iop_state == idle) adb_iop_start();
> +       if (adb_iop_state == idle)
> +               adb_iop_start();
>        iop_ism_irq(0, (void *) ADB_IOP);
>  }
>
> --
> 1.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
