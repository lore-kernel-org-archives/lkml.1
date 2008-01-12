Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbYALEYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbYALEYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 23:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYALEYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 23:24:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:17505 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbYALEYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 23:24:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=fntff0yzhrh35Za+AjoPQR4dMJoaAK7VPoO8zYafb9fOUMDDVr03JJh4g9pV6rm7U84pqQoAsnKST9FfEE3meJZTEvAcGCwW0VAY9mE7Dv7hb1ay2WEx5ZH9zSpZdzpygxXwSI52x//MVKxvwcEekEhMfjmU+DI6Zl+H0KPG18A=
Message-ID: <4cc25cb20801112024h41192eb1m253a09feeb4ccc61@mail.gmail.com>
Date: Sat, 12 Jan 2008 12:24:37 +0800
From: "=?BIG5?B?qfqp+qX0?=" <mingming.nk@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: problem about try_module_get(struct module *module)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 I have a problem about the try_module_get function, I don't know if someone
removed the module just AFTER line 372, then what happens? Because in this
situation, the variable module will be incorrect, and module_is_live
function will
lead to unpredicatable behaviour.

368 static inline int try_module_get(struct module *module)
369 {
370         int ret = 1;
371
372         if (module) {
373                 unsigned int cpu = get_cpu();
374                 if (likely(module_is_live(module)))
375                         local_inc(&module->ref[cpu].count);
376                 else
377                         ret = 0;
378                 put_cpu();
379         }
380         return ret;
381 }

Best wishes to all,
rmingming
