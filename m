Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbZERNqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbZERNqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 09:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZERNpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 09:45:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:64575 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZERNpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 09:45:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=d3qBsfiMnaIsIlVHHQsAM6hGfA5ceqEeJkosyfTXjhvE/tDKGUVIy+cmiK7s+lG6qr
         AHHeVsDFAhD6mQRBw53QKuG44FBvU9/Qi8bkBE5+j6Ic30b6XLG5x9AfkBFjcKlxnDiW
         7dchWGjXzIFvb6qYlLsUbpBSE67UyLmrFVnug=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH 6/6] drivers/ide: Convert printk(KERN_NOTICE to pr_notice(
Date: Mon, 18 May 2009 15:50:07 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Joe Perches <joe@perches.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <cover.1242609803.git.joe@perches.com> <4A11343C.5070809@ru.mvista.com> <m3skj2im12.fsf@intrepid.localdomain>
In-Reply-To: <m3skj2im12.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905181550.07723.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 May 2009 15:22:01 Krzysztof Halasa wrote:
> Sergei Shtylyov <sshtylyov@ru.mvista.com> writes:
> 
> >>  			} else {
> >>  				floppy->blocks = blocks;
> >>  				floppy->block_size = length;
> >>  				floppy->bs_factor = length / 512;
> >>  				if (floppy->bs_factor != 1)
> >> -					printk(KERN_NOTICE PFX "%s: Warning: "
> >> -					       "non 512 bytes block size not "
> >> -					       "fully supported\n",
> >> -					       drive->name);
> >> +					pr_notice(PFX "%s: Warning: non 512 bytes block size not fully supported\n",
> >>   
> >
> >   Again.
> 
> (> 80 chars in line)
> 
> Though I think most people would agree that the latter is much better,
> no?

No, it just hides the real issue:

Please factor out descriptor parsing from ide_floppy_get_capacity()
and remove superfluous "Warning: " part of the message instead if you
want something much better.

It is also a real pain for people depending on some kind of automatic
verification of patches (infamous checkpatch.pl ;).

> I think removal (rewording) of this rule has already been agreed upon,
> though not exactly yet codified.

This is not a strict rule but in 99% cases it shows that the code could
be improved further without >80 chars lines.

Thanks.
Bart
