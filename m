Return-Path: <linux-kernel-owner+w=401wt.eu-S1763296AbXFRKIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763296AbXFRKIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761505AbXFRJ7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:59:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50255
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761352AbXFRJ71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:59:27 -0400
Date: Mon, 18 Jun 2007 02:59:45 -0700 (PDT)
Message-Id: <20070618.025945.123705241.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: akpm@linux-foundation.org, viro@ftp.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race in AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1I0Dx9-00071X-00@dorka.pomaz.szeredi.hu>
References: <E1I0DmJ-0006yg-00@dorka.pomaz.szeredi.hu>
	<20070618.024807.45712241.davem@davemloft.net>
	<E1I0Dx9-00071X-00@dorka.pomaz.szeredi.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 11:55:19 +0200

> It's doing trylocks and releasing all those locks within the same spin
> locked region, how the f**k can that deadlock?

The case I'm very concerned about is the interactions of your
new code with the unix_state_double_lock() stuff I added recently
to fix another bug.
