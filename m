Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbXJBH3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbXJBH3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbXJBH27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:28:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:2789 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbXJBH26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:28:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Jrgbxhndba8sfs6Vq7In/Xs0Ibg+NwnONR7gSnS3N6zdDdxs0/5SCLjeY9Dy5mlwbrJlzSRPG3g6wQB2LTsYEnQmZweESjkPncKjbFmc5ZASjpq20oapRI84gP5pqRkf7dH13sJ39RhiZiKU3+uSe2KuUj6Pv/tVP4j5RVQjq7g=
Message-ID: <f69849430710020028l64379652q77e3c9428ef4de79@mail.gmail.com>
Date: Tue, 2 Oct 2007 00:28:57 -0700
From: "kernel coder" <lhrkernelcoder@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: cann't dump info to user file from kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
          I'm trying to dump some information from dev.c to user space
file.Following is the code which i'm using to write to user spcae
file.I'm using 2.6.22.x86_64 kernel.


#define _write(f, buf, sz) (f->f_op->write(f, buf, sz, &f->f_pos))
#define WRITABLE(f) (f->f_op && f->f_op->write)

int write_to_file(char *logfile, char *buf,int size)
{
        int ret = 0;
        struct file *f=NULL;
        mm_segment_t old_fs = get_fs();
        set_fs(get_ds());
         f = filp_open(logfile, O_CREAT|O_APPEND,00600);
        if(IS_ERR(f)){
                DPRINT("Error %ld openeing %s\n",-PTR_ERR(f), logfile);
                ret = -1;
        } else {
                if (WRITABLE(f))
                        _write(f, buf, size);
                else {
                        DPRINT("%s does not have a write method\n",
                                logfile);
                        ret = -1;
                }

                if ((ret = filp_close(f,NULL)))
                        DPRINT("Error %d closing %s\n", -ret, logfile);
        }
        END_KMEM;

        return ret;
}


I'm calling this function from netif_recieve_skb in dev.c

int netif_recieve_skb(struct sk_buff *skb){

---------------------
write_to_file("/root/kernel_log","hello_world",12);
----------------------

}

But whenever this function is called ,the kernel simply halts.Please
tell me what might be the reason.

I just want to dump some information to user spcace file from dev.c
.Is there some better way to do it.


thanks,
shahzad
