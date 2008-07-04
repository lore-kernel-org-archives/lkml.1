Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbYGDGl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbYGDGl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 02:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbYGDGlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 02:41:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:61536 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbYGDGlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 02:41:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ZNnBEWf8mtR71Rn6u1QwXMS6VjKrob7rhSPtcHUs+z3TUkwJfUBmzHPPg3UgjCBiaS
         fGZ0UAmjzjNRJ0WzxUROLM60mLxy4KHnbZnbuGDBigrjqV61T6HzQJzcid5qmOykTY+8
         IBCdtNIwfXf0fJFYisnWhXTpsGVmG4W4HBWA0=
Message-ID: <486DC5D3.5050201@gmail.com>
Date: Fri, 04 Jul 2008 15:40:19 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 06/15] Introduce sysfs_sd_setattr and fix sysfs_chmod
References: <20080618170729.808539948@theryb.frec.bull.fr>	<m18wwmsqdv.fsf@frodo.ebiederm.org> <4869D314.5030403@gmail.com>	<m1ej6enep7.fsf@frodo.ebiederm.org> <486A0751.9080602@gmail.com>	<m1wsk5hjm0.fsf@frodo.ebiederm.org> <486AF4FA.8020805@gmail.com>	<m1ej6d9c2r.fsf@frodo.ebiederm.org> <486B060C.7030607@gmail.com>	<m14p78s02q.fsf@frodo.ebiederm.org> <486C4515.1070007@gmail.com>	<m1hcb7o8lv.fsf@frodo.ebiederm.org> <486CB051.5000507@fr.ibm.com>	<m14p77m9uy.fsf@frodo.ebiederm.org> <486CF71F.5090405@gmail.com>	<m1y74iiidz.fsf_-_@frodo.ebiederm.org>	<m1tzf6ihlz.fsf_-_@frodo.ebiederm.org>	<m1prpuihjb.fsf_-_@frodo.ebiederm.org>	<m1lk0iihhp.fsf_-_@frodo.ebiederm.org>	<m1hcb6ihfz.fsf_-_@frodo.ebiederm.org>	<m1d4luihea.fsf_-_@frodo.ebiederm.org> <m18wwiihbn.fsf_-_@frodo.ebiederm.org>
In-Reply-To: <m18wwiihbn.fsf_-_@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Currently sysfs_chmod calls sys_setattr which in turn calls
> inode_change_ok which checks to see if it is ok for the current user
> space process to change tha attributes. Since sysfs_chmod_file has
> only kernel mode clients denying them permission if user space is the
> problem is completely inappropriate.
> 
> Therefore factor out sysfs_sd_setattr which does not call
> inode_change_ok and modify sysfs_chmod_file to call it.
> 
> In addition setting victim_sd->s_mode explicitly in sysfs_chmod_file
> is redundant so remove that as well.
> 
> Thanks to Tejun Heo <htejun@gmail.com>, and
> Daniel Lezcano <dlezcano@fr.ibm.com> for working on this
> and spotting this case.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
