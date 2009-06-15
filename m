Return-Path: <linux-kernel-owner+w=401wt.eu-S1763892AbZFOQth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763892AbZFOQth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761207AbZFOQt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:49:26 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:35402 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760318AbZFOQtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:49:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=k20ijcBkc11qySt5BlLqKX7+AGiMvcxGa8M5xh5QryX/McSLdLYFsuCoon0o0ebIwM
         jgh5KWqRQZqW1FhT0wzcYsE22ygIL/FAxJRIy+deiGXqOoMIBvGjqQU3gsBM02j50suD
         oq5FcxGSprzYupeUJhOVASvOO0/Urt/OOwOkY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: linux-next: ide tree build failure
Date: Mon, 15 Jun 2009 18:14:12 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090612gcc44-07181-g84f26e4; KDE/4.2.3; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090615113430.21122e44.sfr@canb.auug.org.au> <20090615053514.GA13226@liondog.tnic>
In-Reply-To: <20090615053514.GA13226@liondog.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906151814.13305.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 June 2009 07:35:14 Borislav Petkov wrote:
> Hi,
> 
> On Mon, Jun 15, 2009 at 11:34:30AM +1000, Stephen Rothwell wrote:
> > Today's linux-next build (x86_64 allmodconfig) failed like this:
> > 
> > drivers/ide/ide-tape.c: In function 'idetape_chrdev_open':
> > drivers/ide/ide-tape.c:1515: error: implicit declaration of function 'idetape_read_position'
> > 
> > Caused by commit 55ce3a129ea2e8faba4a11bb5dbc305590d1c20c ("ide-tape: fix
> > READ POSITION cmd handling") interacting with the later merge
> > 8dcce4081305d3d1629190edd112e6473c315cbc ("Merge branch
> > 'bp-remove-pc-buf' into for-next").
> > 
> > I have used the ide tree from next-20090612 for today.
> 
> Ah, the function got renamed in 55ce3a129ea2e8faba4a11bb5dbc305590d1c20c. Here's
> a fix:
> 
> ---
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Mon, 15 Jun 2009 07:32:04 +0200
> Subject: [PATCH] ide-tape: fix build issue
> 
> This fixes
> 
> drivers/ide/ide-tape.c: In function `idetape_chrdev_open':
> drivers/ide/ide-tape.c:1515: error: implicit declaration of function `idetape_read_position'
> make[1]: *** [drivers/ide/ide-tape.o] Error 1
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

thanks, applied
