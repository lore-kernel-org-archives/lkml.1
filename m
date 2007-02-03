Return-Path: <linux-kernel-owner+w=401wt.eu-S1750853AbXBCRfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750853AbXBCRfX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 12:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbXBCRfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 12:35:22 -0500
Received: from ultra7.eskimo.com ([204.122.16.70]:2215 "EHLO ultra7.eskimo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbXBCRfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 12:35:22 -0500
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Feb 2007 12:35:22 EST
Date: Sat, 3 Feb 2007 09:22:04 -0800
From: Elladan <elladan@eskimo.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-kernel@vger.kernel.org, Sunil Naidu <akula2.shark@gmail.com>,
       Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>
Subject: Re: Abysmal disk performance, how to debug?
Message-ID: <20070203172204.GA29334@eskimo.com>
References: <200701201920.54620.ismail@pardus.org.tr> <20070120174503.GZ24090@1wt.eu> <200701201952.54714.ismail@pardus.org.tr> <20070120180344.GA23841@1wt.eu> <8355959a0701201144x290362d8ja6cd5bc1408475da@mail.gmail.com> <45B273E4.8040302@seclark.us> <20070120200916.GB25307@1wt.eu> <45BBAB48.9060304@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BBAB48.9060304@tmr.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You guys are making this harder than it needs to be.  Try this:

sync 	# To make sure nothing else is writing
dd if=/dev/zero of=file bs=1M count=1024 oflag=dsync

You'll get reasonable numbers this way out of dd.

-J

On Sat, Jan 27, 2007 at 02:43:04PM -0500, Bill Davidsen wrote:
> What you want is this:
>   sync;
>   time bash -c "dd if=/dev/zero of=/tmp/1GB bs=1M count=1024; sync"
> which will actually time the write with the time command.
