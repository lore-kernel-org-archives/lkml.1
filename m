Return-Path: <linux-kernel-owner+w=401wt.eu-S1030275AbXCVIQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030275AbXCVIQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 04:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030266AbXCVIP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 04:15:29 -0400
Received: from www.cosmosbay.com ([86.65.150.131]:46960 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965844AbXCVIPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 04:15:24 -0400
Date: Thu, 22 Mar 2007 09:14:45 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Problem with fix-rmmod-read-write-races-in-proc-entries.patch in
 2.6.21-rc4-mm1
Message-Id: <20070322091445.0eecd44f.dada1@cosmosbay.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 22 Mar 2007 09:14:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

It seems you are fix-rmmod-read-write-races-in-proc-entries.patch author ?

/proc/kcore is no longer seekable (or mappable)

Also, do we really need to proxy via proc_reg_file_ops files that are not provided by a module ?

I think not.

Could you please add in proc_get_inode() a check against de->proc_fops->owner ?

if (de->proc_fops) {
#ifdef CONFIG_MODULE
    if (S_ISREG(inode->i_mode) && de->proc_fops->owner)
        inode->i_fop = &proc_reg_file_ops;
    else
#endif
        inode->i_fop = de->proc_fops;
}

Maybe the whole proc_reg_XXX() functions could be omitted for a kernel without module support ?

Thank you
Eric
