Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbXI0FuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbXI0FuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 01:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbXI0FuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 01:50:08 -0400
Received: from main.gmane.org ([80.91.229.2]:51417 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbXI0FuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 01:50:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Shreyansh Jain <shreyansh.jain@gmail.com>
Subject: =?utf-8?b?dHJ5X21vZHVsZV9nZXQ=?= code understanding
Date: Thu, 27 Sep 2007 05:19:06 +0000 (UTC)
Message-ID: <loom.20070927T051622-501@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 192.8.220.8 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.7) Gecko/20070914 Firefox/2.0.0.7)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear List,

I agree that this issue certainly doesn't require to be in this list (rightful
place being kernewbies) but I tried that and got no response - so trying my luck
here.

I was going through try_module_get function in include/linux/module.h file
(2.6.22 stock kernel) - which is like:

-----
static inline int try_module_get(struct module *module){
  int ret = 1;   <--- error case when !module
    if (module) {
         unsigned int cpu = get_cpu();
         if (likely(module_is_live(module)))
                local_inc(&module->ref[cpu].count);
         else
                ret = 0;   <--- error case
         put_cpu();
  }
  return ret;   <----
}
----

What I understand about the code flow is:
-- module live would return the flag stating that this module can be reference
and is NOT being removed currently.

1. In case the module pointer passed is invalid (NULL) this function would
return 1 (error case)
2. In case the module pointer is OK, and module is currently not being removed,
reference count would be incremented and 1 returned (non error case)
3. In case the module pointer is OK, and module reference count can NOT be
increased, 0 would be returned (error case).

As you can observe from above points, 0 and 1 are returned for error cases. I am
a little confused and wondering if there is something which I am missing in this
code??.

Can anyone help me out with this? Any help would be highly appreciated.

Regards
Shreyansh

