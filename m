Return-Path: <linux-kernel-owner+w=401wt.eu-S1758936AbXLLLDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbXLLLDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbXLLLD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:03:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53927 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbXLLLD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:03:26 -0500
Subject: Re: 2.6.24-rc5 "videobuf_read_start"
	[drivers/media/video/videobuf-dvb.ko] undefined!
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Shane <gnome42@gmail.com>, Brandon Philips <brandon@ifup.org>,
       linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>
In-Reply-To: <20071212090709.GF14204@stusta.de>
References: <fa4052ef0712112120l1165af5btc108ea2131760328@mail.gmail.com>
	 <20071212090709.GF14204@stusta.de>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 09:03:14 -0200
Message-Id: <1197457394.4807.40.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Any objections against a later path that changes the exports to the 
> general "immediately after the function" convention?

No objections. Please generate against "devel" branch on my -git, since
I did a patch fixing most CodingStyle issues reported by checkpatch.pl.

Several files under /media still uses the old convention of having such
things at the end of the file.

> It would have avoided at least two such bugs in this file alone since 
> 2.6.23...

I'm afraid that this wouldn't avoid this bug, however. 

The removal of the EXPORT_SYMBOL_GPL seemed to be the intention of
Brandon, since he renamed the function, removing the locks. I think he
didn't noticed that videobuf_dvb were using videobuf_read_start. The
patch I've just send fixes it properly.

Btw, Shane patch reveals a small trouble with EXPORT_SYMBOL_GPL: adding
the tag for a non-existing function didn't rise any error. IMO, it
should generate some compilation error, if you try to export a symbol
that doesn't exist at the file that is being compiled.
 
Cheers,
Mauro

