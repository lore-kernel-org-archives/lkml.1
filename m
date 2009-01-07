Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbZAGGAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbZAGGAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 01:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZAGGAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 01:00:30 -0500
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:53289 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbZAGGA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 01:00:29 -0500
Message-ID: <496444F9.2020202@freemail.hu>
Date: Wed, 07 Jan 2009 07:00:25 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: pair of alloc_disk()?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail00d.mail.t-online.hu 32720; Body=1 Fuz1=1
	Fuz2=1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I cannot find free_disk() or similar function which takes "struct gendisk"
as a parameter and can do the reverse thing what alloc_disk() do.

Could you please give me a hint what would be the correct function call
in the following example in test_exit_module() so the module do not leak?


#include <linux/module.h>
#include <linux/genhd.h>

MODULE_AUTHOR("Márton Németh <nm127@freemail.hu>");
MODULE_DESCRIPTION("Test alloc_disk");
MODULE_LICENSE("GPL");

static struct gendisk *gd_ptr;

static int test_init_module(void)
{
        printk(KERN_DEBUG "starting module\n");

        gd_ptr = alloc_disk(1);
        if (!gd_ptr) {
                return -ENOMEM;
        }

        printk(KERN_DEBUG "gd_ptr after alloc=%p\n", gd_ptr);

        return 0;
}


static void test_exit_module(void)
{
        printk(KERN_DEBUG "unloading module\n");

        /* FIXME: no free_disk(gd_ptr) is available */
}

module_init(test_init_module);
module_exit(test_exit_module);

Regards,

	Márton Németh
