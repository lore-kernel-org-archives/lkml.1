Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbYJ0TmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbYJ0TmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYJ0Tlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:41:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54555
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751673AbYJ0Tlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:41:51 -0400
Date: Mon, 27 Oct 2008 12:41:26 -0700 (PDT)
Message-Id: <20081027.124126.74749150.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: benjamin.thery@bull.net, serue@us.ibm.com, netdev@vger.kernel.org,
       gregkh@suse.de, viro@ftp.linux.org.uk, dlezcano@fr.ibm.com,
       linux-kernel@vger.kernel.org, htejun@gmail.com, den@openvz.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH] netns: Coexist with the sysfs limitations v2
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1fxmni9uv.fsf_-_@frodo.ebiederm.org>
References: <20081022212124.GA9910@us.ibm.com>
	<49003019.40904@bull.net>
	<m1fxmni9uv.fsf_-_@frodo.ebiederm.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 23 Oct 2008 08:56:08 -0700

> To make testing of the network namespace simpler allow
> the network namespace code and the sysfs code to be
> compiled and run at the same time.  To do this only
> virtual devices are allowed in the additional network
> namespaces and those virtual devices are not placed
> in the kobject tree.
> 
> Since virtual devices don't actually do anything interesting
> hardware wise that needs device management there should
> be no loss in keeping them out of the kobject tree and
> by implication sysfs.  The gain in ease of testing
> and code coverage should be significant.
> 
> Changelog:
> 
> v2: As pointed out by Benjamin Thery it only makes sense to call
>     device_rename in the initial network namespace for now.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Acked-by: Benjamin Thery <benjamin.thery@bull.net>
> Tested-by: Serge Hallyn <serue@us.ibm.com>
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> Acked-by: Daniel Lezcano <dlezcano@fr.ibm.com>

So let's figure out what happens with this patch.
I'm personally ok with the change, the question is when
and where.

My net-2.6 tree was closed to new features long ago, so I really
don't want to try to merge this sucker into 2.6.28-rcX :-)  But if
you guys think that is prudent, feel free to submit it directly to
Linus and add my signoff:

Signed-off-by: David S. Miller <davem@davemloft.net>

otherwise if we shoot for 2.6.29 I would suggest that we wait until
the merge window to see if the sysfs issues get sorted, and if not
we slip this patch into to tree instead.

Let me know what you guys plan to do with this.
