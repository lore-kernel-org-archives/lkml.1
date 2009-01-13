Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZAMVKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZAMVKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZAMVKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:10:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37883
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750770AbZAMVK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:10:29 -0500
Date: Tue, 13 Jan 2009 13:10:30 -0800 (PST)
Message-Id: <20090113.131030.207355839.davem@davemloft.net>
To: jesper.nilsson@axis.com
Cc: tj@kernel.org, gregkh@suse.de, stern@rowland.harvard.edu,
       jens.axboe@oracle.com, hinko.kocevar@cetrtapot.si,
       linux-kernel@vger.kernel.org
Subject: Re: lib/klist.c: bit 0 in pointer can't be used as flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090113151406.GC19262@axis.com>
References: <20090113151406.GC19262@axis.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Nilsson <jesper.nilsson@axis.com>
Date: Tue, 13 Jan 2009 16:14:06 +0100

> The commit a1ed5b0cffe4b16a93a6a3390e8cee0fbef94f86
> (klist: don't iterate over deleted entries) introduces use of the
> low bit in a pointer to indicate if the knode is dead or not,
> assuming that this bit is always free.
> 
> This is not true for all architectures, CRIS for example may align data
> on byte borders.

There are many other spots in the kernel where the low bits of a
pointer are hijacked as status bits.  Lots of other things cannot
possible be working on CRIS because of this.
