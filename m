Return-Path: <linux-kernel-owner+w=401wt.eu-S1761705AbXEaMfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761705AbXEaMfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 08:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757762AbXEaMfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 08:35:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:12508 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368AbXEaMfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 08:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=O/MnRBlorfVIk6lIhWa6fRE8LNg3hfgD4OFcS/sYH+9ikcEa4mWMnxzvIFe32nYisxv9I4t0cDNioU6s2c6jVQHVwpQyPOIU9xWUmxBO94uBTGduK4LS3zb3GXrjjQuXvDhHlFdc3Bnf2n7n+S9i3RmLfIGGFsc4xyZKV+wNW7w=
Message-ID: <2bd9ebfa0705310535j412f11f4tfd2b44a5a4d04cfc@mail.gmail.com>
Date: Thu, 31 May 2007 18:05:34 +0530
From: "Tej Parkash" <tejparkash.d@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: reg: kprobe method
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi all

there is some problem in adding simple printk using kprobe method

i m posting the my code anybody can suggest how to make it work

#include<linux/kernel.h>
#include<linux/version.h>
#include<linux/module.h>
#include<linux/init.h>
#include<linux/kprobes.h>
#include<linux/kallsyms.h>

MODULE_AUTHOR("TEJ");
MODULE_LICENSE("GPL");
//MODULE_PARM(int,val,I_IRUGO);

struct kprobe kp;
static int handler_pre(struct kprobe *p, struct pt_regs *regs)
{
 printk("my name is tej parkash dhiman");
        return 0;
}


void handler_post(struct kprobe *p, struct pt_regs *regs, unsigned long flags)
{
        printk("mast hai na tej ash ker");
}

static int init_mod(void)
{

struct kprobe kp;
kp.post_handler=handler_post;
kp.pre_handler=handler_pre;

kp.addr = (kprobe_opcode_t *) 0xc0278e50; //add for __sock_create

if(kp.addr== NULL) {
                printk("kallsyms_lookup_name could not find address
for the specified symbol name\n");
                return 0;
                    }

register_kprobe(&kp);
printk("Module is inserted");
return 0;
}
void exit_mod(void)
{
unregister_kprobe(&kp);
printk("module is removed");
}
module_init(init_mod);
module_exit(exit_mod);

thanks
TEJ
