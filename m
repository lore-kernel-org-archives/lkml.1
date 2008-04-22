Return-Path: <linux-kernel-owner+w=401wt.eu-S1763002AbYDVVVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763002AbYDVVVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762369AbYDVVVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:21:18 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:48591 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761714AbYDVVVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HBR563uiqEED8dpIDn0NhOnOgFCSFr9K/8LjJGyNCya019DEf0m3HtIjlR2wCVmiI3al8lcFgkbFd/ZYDAyXfTXp7nVjEf/Rgpa9J+iTz/pM2bpZlHsbTTEmGjJeJroOIRsraoQHDYE9cfKjagUkIGUzX+/V/N5sCvgI3LWiLsY=
Message-ID: <9a8748490804221421x43271510nac6934f1ce37f500@mail.gmail.com>
Date: Tue, 22 Apr 2008 23:21:10 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH] hfs: if match_strdup() fails to allocate memory in parse_options(), don't blow up the kernel.
Cc: "Roman Zippel" <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1208899044.8636.80.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.00.0804222309250.14359@dragon.funnycrock.com>
	 <1208899044.8636.80.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/04/2008, Joe Perches <joe@perches.com> wrote:
> On Tue, 2008-04-22 at 23:12 +0200, Jesper Juhl wrote:
>  > From: Jesper Juhl <jesper.juhl@gmail.com>
>
> > diff --git a/fs/hfs/super.c b/fs/hfs/super.c
>  > index 32de44e..221e314 100644
>  > --- a/fs/hfs/super.c
>  > +++ b/fs/hfs/super.c
>  > @@ -297,6 +297,10 @@ static int parse_options(char *options, struct hfs_sb_info *hsb)
>  >                               return 0;
>  >                       }
>  >                       p = match_strdup(&args[0]);
>  > +                     if (!p) {
>  > +                             printk(KERN_ERR "hfs: mem alloc failed in match_strdup()\n");
>  > +                             return 0;
>  > +                     }
>  >                       hsb->nls_disk = load_nls(p);
>  >                       if (!hsb->nls_disk) {
>  >                               printk(KERN_ERR "hfs: unable to load codepage \"%s\"\n", p);
>  > @@ -311,6 +315,10 @@ static int parse_options(char *options, struct hfs_sb_info *hsb)
>  >                               return 0;
>  >                       }
>  >                       p = match_strdup(&args[0]);
>  > +                     if (!p) {
>  > +                             printk(KERN_ERR "hfs: memory allocation failed in match_strdup()\n");
>  > +                             return 0;
>  > +                     }
>  >                       hsb->nls_io = load_nls(p);
>  >                       if (!hsb->nls_io) {
>  >                               printk(KERN_ERR "hfs: unable to load iocharset \"%s\"\n", p);
>  >
>
>
> Using different strings in the printk wastes memory.
>

True, but I personally prefer being able to do  grep "error message"
and hit just one source location over saving a few bytes of memory...
If Roman wants the strings to be identical I can resubmit the patch. Roman?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
