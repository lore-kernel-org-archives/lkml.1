Return-Path: <linux-kernel-owner+w=401wt.eu-S1030201AbXBLWIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030201AbXBLWIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030202AbXBLWIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:08:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43380 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030201AbXBLWIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:08:07 -0500
Date: Mon, 12 Feb 2007 14:08:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regress for 8139too in 2.6.20
Message-Id: <20070212140800.4d9378ad.akpm@linux-foundation.org>
In-Reply-To: <45CFAED5.2090808@lwfinger.net>
References: <45CFAED5.2090808@lwfinger.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 11 Feb 2007 18:03:33 -0600 Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In kernel version 2.6.20, my network interface, a Uniden PCN 300 PCMCIA card that uses the 8139too
> driver fails to initialize with Yenta and 8139too as modules. It worked correctly in 2.6.19. Using
> git bisect, the bad commit is shown below:
> 
> finger@sonylap:~/linux-2.6> git bisect good
> 8d610dd52dd1da696e199e4b4545f33a2a5de5c6 is first bad commit
> commit 8d610dd52dd1da696e199e4b4545f33a2a5de5c6
> Author: Linus Torvalds <torvalds@woody.osdl.org>
> Date:   Mon Dec 11 12:12:04 2006 -0800
> 
>     Make sure we populate the initroot filesystem late enough
> 
>     We should not initialize rootfs before all the core initializers have
>     run.  So do it as a separate stage just before starting the regular
>     driver initializers.
> 
>     Signed-off-by: Linus Torvalds <torvalds@osdl.org>
> 
> :040000 040000 12bc13def90d15921d41d2b285854b3e157a970f f936e01f6b1b2b75478484861d34e81830c73860 M
>     include
> :040000 040000 5673719c3f6b47b329cfc9554c112077634a9b19 9c2e768964af1500d62849836b9f8e801fe7f29e M
>     init
> 
> 
> If Yenta is built into the kernel, rather than a module, it works again with 2.6.20.
> 

That's a bit surprising - the initcall levels don't affect modules. 
Presumably something went wrong in core kernel which later caused yenta
and/or 8139too to fail.

Have you tried diffing the before- and after-dmesgs to see if that particular
commit has caused any interesting differences?

And are you able to test any other cardbus devices to see whether it's
specific to 8139too?

