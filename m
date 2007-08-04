Return-Path: <linux-kernel-owner+w=401wt.eu-S1764715AbXHDQOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764715AbXHDQOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 12:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755954AbXHDQOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 12:14:08 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:55634 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759289AbXHDQOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 12:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JN8d+98615Bz4YsxwVzh1vfJ3xocX85im/hgdzrkbyYo5+c4q0RId2F30Ofdw/45RyapCt68LKr3Ks6ehQ2LyEoZLdtSDQUBYSCn6pyf81NlK/4/wlkno3a65ZWuljGQXnoMIIASQR6YX77ciafUPYnPFjCpTfo/WmZcQ8yuETk=
Message-ID: <9a8748490708040914x2959fe0n20c542552120362a@mail.gmail.com>
Date: Sat, 4 Aug 2007 18:14:05 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Len Brown" <lenb@kernel.org>
Subject: Re: [PATCH][ACPI] Let's not gamble that a possible double free will never happen in asus_hotk_get_info()
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Julien Lerouge" <julien.lerouge@free.fr>,
       "Karol Kozimor" <sziwan@users.sourceforge.net>,
       linux-acpi@vger.kernel.org, corentincj@iksaif.net,
       acpi4asus-user@lists.sourceforge.net
In-Reply-To: <200708031614.09792.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707290045.59698.jesper.juhl@gmail.com>
	 <200708031614.09792.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/07, Len Brown <lenb@kernel.org> wrote:
> On Saturday 28 July 2007 18:45, Jesper Juhl wrote:
> > Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> > ---
> >
> > drivers/acpi/asus_acpi.c | 1 +
> > 1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/acpi/asus_acpi.c b/drivers/acpi/asus_acpi.c
> > index 9c4bd22..86fd142 100644
> > --- a/drivers/acpi/asus_acpi.c
> > +++ b/drivers/acpi/asus_acpi.c
> > @@ -1192,6 +1192,7 @@ static int asus_hotk_get_info(void)
> > break;
> > default:
> > kfree(model);
> > +model = NULL;
> > break;
> > }
> > }
>
> applied.
>
> coverity didn't find the bug below this code however.
> we can also leak model in the path that returns  OK.
>
Whoops, I should have spotted that.  I assume you've now fixed that locally?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
