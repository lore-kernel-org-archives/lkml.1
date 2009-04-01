Return-Path: <linux-kernel-owner+w=401wt.eu-S1763373AbZDATWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763373AbZDATWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762164AbZDATWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:22:22 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47833 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760229AbZDATWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:22:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GN4yOaKeRTfswJumiXo85MFK3liIY0DHNICUqYe5ySCdggNfIyWKiHhg6H9Wk0FcRf
         vk4XAyWBaeiFHZmF4+1Nh7fgUuhl0wS0iXWqhpq/zFgWmWwFd1Sb1aG19cL3GG/G33lP
         QScsyVHq/ZPdcnlB8eIJbvMmUOCPiiW0QSFeg=
Subject: Re: [PATCH 1/2] lib: add fast lzo decompressor
From: Andreas Robinson <andr345@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>, linux-kernel@vger.kernel.org
In-Reply-To: <49D3927A.2050406@zytor.com>
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>
	 <1238593252-3435-2-git-send-email-andr345@gmail.com>
	 <49D3927A.2050406@zytor.com>
Content-Type: text/plain
Date: Wed, 01 Apr 2009 21:22:10 +0200
Message-Id: <1238613730.10514.35.camel@andreas-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-01 at 09:12 -0700, H. Peter Anvin wrote:
> Andreas Robinson wrote:
> > This patch adds an LZO decompressor tweaked to be faster than
> > the 'safe' decompressor already in the kernel.
> > 
> > On x86_64, it runs in roughly 80% of the time needed by the safe
> > decompressor.
> > 
> > This function is inherently insecure and can cause buffer overruns.
> > It is only intended for decompressing implicitly trusted data, such
> > as an initramfs and the kernel itself.
> > 
> > As such, the function is neither exported nor declared in a header.
> > 
> 
> OK, I'm more than a bit nervous about that, especially since we're
> trying to make the decompression functions more generic.

Perhaps the system can default to the safe decompressor for normal use
and choose the fast one if STATIC is defined or when system_state ==
SYSTEM_BOOTING?

> Furthermore, is there a specific reason you didn't implent this for the
> kernel itself as well as for the initramfs?  I'd really would strongly
> prefer if the two compression sets didn't diverge.

There is a patch but I wanted to be sure that I had not missed anything
before submtting it, and also have a look at possibly supporting more
architectures. But I'll post it shortly.


