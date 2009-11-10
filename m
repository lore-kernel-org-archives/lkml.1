Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbZKJLma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbZKJLma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbZKJLma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:42:30 -0500
Received: from bamako.nerim.net ([62.4.17.28]:53489 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbZKJLm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:42:29 -0500
Date: Tue, 10 Nov 2009 12:42:31 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Ben Hutchings <bhutchings@solarflare.com>
Cc: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mika Kuoppala <mika.kuoppala@nokia.com>
Subject: Re: linux-next: manual merge of the net tree with the i2c tree
Message-ID: <20091110124231.66141a0f@hyperion.delvare>
In-Reply-To: <20091026133757.7cf87e49.sfr@canb.auug.org.au>
References: <20091026133757.7cf87e49.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen, Ben,

On Mon, 26 Oct 2009 13:37:57 +1100, Stephen Rothwell wrote:
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/sfc/sfe4001.c between commit
> 3f7c0648f727a6d5baf6117653e4001dc877b90b ("i2c: Prevent priority
> inversion on top of bus lock") from the i2c tree and commit
> c9597d4f89565b6562bd3026adbe6eac6c317f47 ("sfc: Merge sfe4001.c into
> falcon_boards.c") from the net tree.
> 
> I have applied the following merge fixup patch (after removing
> drivers/net/sfc/sfe4001.c) and can carry it as necessary.

I've merged the new API to get and release the i2c_adapter mutex:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=afa08974fe80c198b8650f73ed8ab59135ca10d0

Ben, you can adjust your own patches to make use of this API instead of
accessing the i2c_adapter mutex directly. That way, you are no longer
dependent of implementation changes, and this should solve the conflict.

Stephen, you can then drop your fixup patch.

Thanks,
-- 
Jean Delvare
