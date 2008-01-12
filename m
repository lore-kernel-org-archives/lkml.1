Return-Path: <linux-kernel-owner+w=401wt.eu-S1760987AbYALFwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760987AbYALFwb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 00:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYALFwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 00:52:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:45338 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbYALFwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 00:52:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=GZ2J53pq+ImCyVaKElgUbdq75qRsBEbb0dGfwphv6KJCaTjOAwWsXeoqxhPu0qW+ouvR4s6XqnoANGSIoO18FYJCwlWeuwe0GqtTwcfOYTBP2NKih1lKOb4tL7xc2DWt+uAOyroWifujVNTrFpRknTdXP/zqsTM9bk9Zq0nti9E=
Message-ID: <4cc25cb20801112152q324c94aegb71a357d47ba3590@mail.gmail.com>
Date: Sat, 12 Jan 2008 13:52:20 +0800
From: rmingming <mingming.nk@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Qustion on function try_module_get()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 I have a problem about the try_module_get function, I don't know if someone
removed the module just AFTER line 372 and BEFORE line 373, then
what happens? Because in this situation, the variable "module" will be
incorrect, and module_is_live function will lead to unpredicatable behaviour.

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
