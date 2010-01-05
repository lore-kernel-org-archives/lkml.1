Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351Ab0AETDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0AETDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562Ab0AETDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:03:09 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:55241 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab0AETDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:03:06 -0500
Subject: Xorg hangs on >= ~2.6.31 with Intel i915 driver
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Zhenyu Wang <zhenyu.z.wang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       David Airlie <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Anholt <eric@anholt.net>
Content-Type: text/plain
Date: Tue, 05 Jan 2010 11:02:48 -0800
Message-Id: <1262718168.7057.29.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been seeing hangs when X starts up with newer kernels.  I sometimes
get a cursor on the screen, sometimes not.  I can move the cursor when I
can see it, but I can't switch to a text console.  Sysrq works.

I bisected down to this commit:

commit 176616814d700f19914d8509d9f65dec51a6ebf7
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Mon Jul 27 12:59:57 2009 +0100

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=176616814d700f19914d8509d9f65dec51a6ebf7

However, backing that commit out of current mainline
(v2.6.33-rc2-302-gc5974b8) doesn't seem to do any good.  It didn't back
out cleanly so I did it by hand and could have easily made a mistake in
the process.

Doing this:

	http://sr71.net/~dave/linux/xhangs/fix-config.patch

to the config worked around the issue in current mainline, although I'm
not quite sure why.

Some additional debug information is here:

	http://sr71.net/~dave/linux/xhangs/

including X logs and dmesg from a bunch of boots. 

-- Dave

