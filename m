Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbYAOJil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbYAOJil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 04:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbYAOJie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 04:38:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35909 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425AbYAOJid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 04:38:33 -0500
Date: Tue, 15 Jan 2008 01:38:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernd Schubert <bernd-schubert@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sleep before boot panic
Message-Id: <20080115013847.35dad92e.akpm@linux-foundation.org>
In-Reply-To: <200801061908.43010.bernd-schubert@gmx.de>
References: <200801061908.43010.bernd-schubert@gmx.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008 19:08:42 +0100 Bernd Schubert <bernd-schubert@gmx.de> wrote:

> Hi,
> 
> I just switched to libata (pata) on my laptop and the immediate panic made it 
> impossible to figure out why my boot partition wasn't available.
> After applying this little patch I could check boot printk output and then saw 
> everything was properly recognized and only scsi-disk support was missing.
> 
> 
> Signed-off-by: Bernd Schubert <bernd-schubert@gmx.de>
> 
> Index: zd1211rw.git.beno/init/do_mounts.c
> ===================================================================
> --- zd1211rw.git.beno.orig/init/do_mounts.c	2008-01-06 18:44:23.000000000 
> +0100

Your email client is wordwrapping things.

> +++ zd1211rw.git.beno/init/do_mounts.c	2008-01-06 18:45:44.000000000 +0100
> @@ -330,6 +330,7 @@
>  		printk("Please append a correct \"root=\" boot option; here are the 
> available partitions:\n");
>  
>  		printk_all_partitions();
> +		msleep(60 * 1000);
>  		panic("VFS: Unable to mount root fs on %s", b);
>  	}

We could borrow the existing pause_on_oops stuff and use it in panic().

Or we could copy it into a new pause_on_panic, but it's hard to see a use
case where they need to be separate.

