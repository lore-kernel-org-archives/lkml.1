Return-Path: <linux-kernel-owner+w=401wt.eu-S1763154AbYDNXNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763154AbYDNXNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 19:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbYDNXNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 19:13:10 -0400
Received: from rv-out-0708.google.com ([209.85.198.247]:13548 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755068AbYDNXNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 19:13:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=B1QjDz/k+XwKOKSu7EZsZtjvlFAtMGUuEb8GXR0jP6n1pN0+5tXnzl4+ydX1APV6yO1BMI2PyGApzDgSfy64+vFshpzUZxuIS8vjFhvcr+Eg3svKHgrSFQ/1j9bhSF/LmQkWWDUCe3LsY9Rsfkcindo6FnRtvnSgbvCFQ+FC61g=
Subject: Re: [PATCH-mm 11/15] video: Use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080414230557.GD9785@ZenIV.linux.org.uk>
References: <1208213280.11920.41.camel@brick>
	 <20080414230557.GD9785@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 16:13:09 -0700
Message-Id: <1208214789.11920.52.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-15 at 00:05 +0100, Al Viro wrote:
> On Mon, Apr 14, 2008 at 03:48:00PM -0700, Harvey Harrison wrote:
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> >  drivers/video/matrox/matroxfb_misc.c |   28 ++++++++++++++--------------
> >  drivers/video/metronomefb.c          |    9 +++------
> >  2 files changed, 17 insertions(+), 20 deletions(-)
> > 
> > diff --git a/drivers/video/matrox/matroxfb_misc.c b/drivers/video/matrox/matroxfb_misc.c
> > index ab7fb50..cfb5205 100644
> > --- a/drivers/video/matrox/matroxfb_misc.c
> > +++ b/drivers/video/matrox/matroxfb_misc.c
> > @@ -522,8 +522,6 @@ static void parse_bios(unsigned char __iomem* vbios, struct matrox_bios* bd) {
> >  #endif
> >  }
> >  
> > -#define get_u16(x) (le16_to_cpu(get_unaligned((__u16*)(x))))
> > -#define get_u32(x) (le32_to_cpu(get_unaligned((__u32*)(x))))
> 
> Why not simply change definitions of those?

Could have done, but seeing the number of times it was used in the file
and what the code looked like with it simply replaced, I went for
eliminating the macro.

If you'd prefer a two-patch, replace in macro/replace macro entirely
I could do so.

Harvey

