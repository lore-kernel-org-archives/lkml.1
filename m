Return-Path: <linux-kernel-owner+w=401wt.eu-S1760327AbYALEfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327AbYALEfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 23:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYALEf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 23:35:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:37138 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbYALEf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 23:35:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=x8TBTMGuBNkWsz4eFvjuwpywyxvYQ8urWe2miOCzwvwb1BokhPzSn+BDIGUsYw9myisjUZKKMjjuUHJX73mWfudZEa0JTM1PM0GaveQhYat6zoq5dP/hy7RTky6Vin7UimwU80Rz041ygEQHyN9Yg4ULPn/+c4TSkC5OPql1M4Y=
Message-ID: <4cc25cb20801112035x16c69a40rf3103a73b6cda107@mail.gmail.com>
Date: Sat, 12 Jan 2008 12:35:27 +0800
From: rmingming <mingming.nk@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Is try_module_get buggy?
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
function will lead to unpredicatable behaviour.

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
