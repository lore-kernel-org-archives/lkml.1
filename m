Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYKBVEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYKBVEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYKBVEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:04:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44968
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754144AbYKBVEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:04:34 -0500
Date: Sun, 02 Nov 2008 13:04:09 -0800 (PST)
Message-Id: <20081102.130409.86443785.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       a.beregalov@gmail.com, hugh@veritas.com
Subject: Re: [Bug #11940] Unable to handle kernel paging request at
 iov_iter_copy_from_user_atomic
From: David Miller <davem@davemloft.net>
In-Reply-To: <wOAXuecskPD.A.yGE.qjeDJB@chimera>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
	<wOAXuecskPD.A.yGE.qjeDJB@chimera>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sun,  2 Nov 2008 17:07:10 +0100 (CET)

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11940
> Subject		: Unable to handle kernel paging request at iov_iter_copy_from_user_atomic
> Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> Date		: 2008-11-01 14:23 (2 days old)
> References	: http://marc.info/?l=linux-kernel&m=122554945922521&w=4
> Handled-By	: Hugh Dickins <hugh@veritas.com>
> Patch		: http://marc.info/?l=linux-kernel&m=122556602913200&w=4

Patch is now in Linus's tree:

commit 145e1c0023585e0e8f6df22316308ec61c5066b2
Author: Hugh Dickins <hugh@veritas.com>
Date:   Sat Nov 1 21:41:40 2008 -0700

    sparc64: Fix __copy_{to,from}_user_inatomic defines.
    
    Alexander Beregalov reports oops in __bzero() called from
    copy_from_user_fixup() called from iov_iter_copy_from_user_atomic(),
    when running dbench on tmpfs on sparc64: its __copy_from_user_inatomic
    and __copy_to_user_inatomic should be avoiding, not calling, the fixups.
    
    Signed-off-by: Hugh Dickins <hugh@veritas.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
