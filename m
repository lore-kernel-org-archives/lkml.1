Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbYLFC3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbYLFC3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 21:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbYLFC3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 21:29:24 -0500
Received: from smtp.zeuux.org ([210.51.160.52]:64269 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbYLFC3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 21:29:23 -0500
Date: Sat, 6 Dec 2008 10:29:17 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/3] fix warning of not used variable
Message-ID: <20081206022917.GA7488@ubuntu>
References: <20081204010022.GB17445@ubuntu> <2375c9f90812040336r498cfefbta51b2ae2689a3d5f@mail.gmail.com> <200812051031.08121.rusty@rustcorp.com.au> <2375c9f90812051652n70475986td3f65a3a364e48dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2375c9f90812051652n70475986td3f65a3a364e48dc@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 12:52:56AM +0000, Américo Wang wrote:
>On Fri, Dec 5, 2008 at 12:01 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> On Thursday 04 December 2008 22:06:33 Américo Wang wrote:
>>> On Thu, Dec 4, 2008 at 1:00 AM, Jianjun Kong <jianjun@zeuux.org> wrote:
>>> > fix this warning:
>>> > kernel/module.c:824: warning: 'print_unload_info' defined but not used
>>> > print_unload_info() just used when CONFIG_PROC_FS was defined.
>>> >
>>> > Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
>>>
>>> Reviewed-by: WANG Cong <wangcong@zeuux.org>
>>
>> My main concern is that this adds two new #ifdef sections.  How about marking
>> both cases "inline" instead?
>>
>
>Hi, sorry for the delay.
>
>Er, making them inline can solve this problem?

I have make a new patch, and it can compile without any warning :)

---
From: Jianjun Kong <jianjun@zeuux.org>
Date: Sat, 6 Dec 2008 10:19:09 +0800
Subject: [PATCH] kernel/module.c: fix compile warning
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Fix this warning:
kernel/module.c:824: warning: ‘print_unload_info’ defined but not used
print_unload_info() just was used when CONFIG_PROC_FS was defined.
This patch mark print_unload_info() inline to solve the problem.

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>
CC: Américo Wang <xiyou.wangcong@gmail.com>
---
 kernel/module.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 1f4cc00..e67f2f8 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -820,7 +820,7 @@ sys_delete_module(const char __user *name_user, unsigned int flags)
 	return ret;
 }
 
-static void print_unload_info(struct seq_file *m, struct module *mod)
+static inline void print_unload_info(struct seq_file *m, struct module *mod)
 {
 	struct module_use *use;
 	int printed_something = 0;
@@ -893,7 +893,7 @@ void module_put(struct module *module)
 EXPORT_SYMBOL(module_put);
 
 #else /* !CONFIG_MODULE_UNLOAD */
-static void print_unload_info(struct seq_file *m, struct module *mod)
+static inline void print_unload_info(struct seq_file *m, struct module *mod)
 {
 	/* We don't know the usage count, or what modules are using. */
 	seq_printf(m, " - -");
-- 
1.5.6.3


-- 
Jianjun Kong | Happy Hacking
HOMEPAGE: http://kongove.cn/
GTALK: kongjianjun@gmail.com
