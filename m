Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbYL1VhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbYL1VhM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 16:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYL1Vgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 16:36:54 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:50751 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142AbYL1Vgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 16:36:53 -0500
Date: Sun, 28 Dec 2008 14:36:36 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: ?ric Piel <E.A.B.Piel@tudelft.nl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH, resend] relatime: Let relatime update atime at least once per day
Message-ID: <20081228213636.GB2002@parisc-linux.org>
References: <20081228152901.GB13565@srcf.ucam.org> <4957CDD2.9040903@tudelft.nl> <20081228195921.GB19176@srcf.ucam.org> <4957EEA7.3050101@tudelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4957EEA7.3050101@tudelft.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2008 at 10:24:55PM +0100, ?ric Piel wrote:
> Yes, it might bring important drawbacks: performance-wise, relatime will
> become more like atime, making it much less useful. There is also a
> significant number of desktop computers that are turned on once a day,
> the boot time may get hindered by those additional writes.

Huh?  Nobody's ever claimed that atime writes cost a significant amount
of performance.  The problem that relatime is designed to solve is
*spin-up* when a file is accessed.

> Actually, you are changing relatime from a boolean condition (maximum
> one additional write per write) to a atime with a coarse grain (maximum
> one additional write per day). Today you found a use case that needs a
> precision of one day. Tomorrow, someone else will find a use case that
> needs a precision of one hour. So maybe what is actually needed is a
> third option, a "grainatime" option where you can change the precision
> of the atime.

You're really over-thinking this.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
