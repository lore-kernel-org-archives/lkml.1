Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbZHGIxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbZHGIxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757204AbZHGIxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:53:41 -0400
Received: from telenet.ba.be ([81.83.8.189]:58303 "EHLO antispam.ba.be"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757198AbZHGIxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:53:41 -0400
X-Greylist: delayed 1267 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Aug 2009 04:53:40 EDT
From: Maarten Vanraes <maarten.vanraes@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: ipmisensors
Date: Fri, 7 Aug 2009 10:30:37 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908071030.38084.maarten.vanraes@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

( I would like to request that you CC me in replies )

I'm trying to fix the ipmisensors patch to 2.6.30.2 (which is the xen-based 
kernel i now use; the patch was written for 2.6.17 and contains numerous 
deprecated code)

I do have the problem that the ipmi_msghandler module doesn't seem to generate 
events at modprobe.

the  ipmisensors_new_smi, ipmisensors_smi_gone &  ipmisensors_msg_handler are 
never executed...

can i get any hints?

Kind regards,

Maarten


/* ipmisensors driver data */
static struct ipmisensors_data driver_data = {
        .driver_name = "bmc",
        .bmc_data = LIST_HEAD_INIT(driver_data.bmc_data),
        .interfaces = 0,
        .smi_watcher = {
                        .owner = THIS_MODULE,
                        .new_smi = ipmisensors_new_smi,
                        .smi_gone = ipmisensors_smi_gone,
                        },
        .ipmi_hndlrs = {
                        .ipmi_recv_hndl = ipmisensors_msg_handler,
                        },
};

....

in __init function:

        /* register IPMI interface callback(s) */
        error = ipmi_smi_watcher_register(&driver_data.smi_watcher);
        if (error) {
                printk(KERN_WARNING
                       "ipmisensors: can't register smi watcher\n");
                return error;
        }

