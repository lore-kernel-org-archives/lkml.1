Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbYGYUsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbYGYUsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 16:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbYGYUsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 16:48:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343AbYGYUsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 16:48:04 -0400
Date: Fri, 25 Jul 2008 13:47:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce lower_32_bits() macro
Message-Id: <20080725134759.ae19b883.akpm@linux-foundation.org>
In-Reply-To: <4889FA03.6010708@zytor.com>
References: <1216998747-16896-1-git-send-email-joerg.roedel@amd.com>
	<4889FA03.6010708@zytor.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 12:06:27 -0400
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Joerg Roedel wrote:
> > The file kernel.h contains the upper_32_bits macro. This patch adds the other
> > part, the lower_32_bits macro. Its first use will be in the driver for AMD
> > IOMMU.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  include/linux/kernel.h |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index f9cd7a5..6fd2977 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -73,6 +73,12 @@ extern const char linux_proc_banner[];
> >   */
> >  #define upper_32_bits(n) ((u32)(((n) >> 16) >> 16))
> >  
> > +/**
> > + * lower_32_bits - return bits 0-31 of a number
> > + * @n: the number we're accessing
> > + */
> > +#define lower_32_bits(n) ((n) & 0xffffffffULL)
> > +
> 
> NAK.  These are assymmetric with regards to type, which is the *last* 
> thing we want.

Yes, it will convert a 32-bit expression into a 64-bit one.

> The symmetric definition would be ((u32)(n)), but that's already 
> idiomatic use, so why not use it as-is?

There's some readability benefit.  Sometimes it is hard to understand
why some random open-coded cast was used.  But I seem to recall that
there was another reason why we decided we needed this.  I forget, and
so apparently did the changelog author ;)


