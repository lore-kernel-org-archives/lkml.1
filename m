Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab0CCHKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:10:36 -0500
Received: from mail-bw0-f212.google.com ([209.85.218.212]:58337 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab0CCHKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:10:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=clD5shDBQfbwkuZCTsQ+MBbab+83mnLIG3zO+rtRdyiuUlU/2jhiOPjSdiqCx523Yi
         mY1bSU8d8+FauTjuF+4+tM4xrXprEG9U8REJeFXKmehOYt5/Z4XW6YAV3+QUTvJNatbx
         0ryDoJ7Vhh28rzYEJYuGBnxPfQ/lM8TxzKWxQ=
Date: Wed, 3 Mar 2010 10:10:23 +0300
From: Dan Carpenter <error27@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: tim@weberpafrica.com, gregkh@suse.de, devel@driverdev.osuosl.org,
       Tim Schofield <tim.schofield1960@googlemail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: verifying whitespace patches don't change anything was Re: [PATCH]
	Staging:rtl8192e: fix comments
Message-ID: <20100303071023.GF5086@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg KH <greg@kroah.com>, tim@weberpafrica.com, gregkh@suse.de,
	devel@driverdev.osuosl.org,
	Tim Schofield <tim.schofield1960@googlemail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1266338116-27482-1-git-send-email-tim@weberpafrica.com> <20100218160547.GJ21785@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100218160547.GJ21785@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 08:05:47AM -0800, Greg KH wrote:
> On Tue, Feb 16, 2010 at 04:35:16PM +0000, tim@weberpafrica.com wrote:
> > From: Tim Schofield <tim.schofield1960@googlemail.com>
> > 
> > ---
> >  drivers/staging/rtl8192e/r8180_93cx6.c |   22 ++++++++++++++--------
> >  1 files changed, 14 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/staging/rtl8192e/r8180_93cx6.c b/drivers/staging/rtl8192e/r8180_93cx6.c
> > index 262ed5f..60fba80 100644
> > --- a/drivers/staging/rtl8192e/r8180_93cx6.c
> > +++ b/drivers/staging/rtl8192e/r8180_93cx6.c
> > @@ -23,12 +23,14 @@
> >  static void eprom_cs(struct net_device *dev, short bit)
> >  {
> >  	if (bit)
> > +		/* enable EPROM */
> >  		write_nic_byte(dev, EPROM_CMD,
> >  			       (1<<EPROM_CS_SHIFT) | \
> > -			       read_nic_byte(dev, EPROM_CMD)); //enable EPROM
> > +			       read_nic_byte(dev, EPROM_CMD));
> >  	else
> > +		/* disable EPROM */
> >  		write_nic_byte(dev, EPROM_CMD, read_nic_byte(dev, EPROM_CMD)\
> > -			       &~(1<<EPROM_CS_SHIFT)); //disable EPROM
> > +			       &~(1<<EPROM_CS_SHIFT));
> 
> This does not do what you think it does (hint, you need {} if you want
> to have more than one line in an if statement...)
> 
> Can you always verify that your coding style changes do not actually
> break the code?  A simple comparison of the .ko file before and after
> should be sufficient.
> 

That's what I thought too, but every debug macro has a __LINE__ in it so 
if you add a new line at the start of the file it makes a ton of changes in
the final binary .ko file.

Is there a trick to this?

I hacked sparse to always use 12345 as the line, but if, for example, you 
remove uneeded parenthesis that would still count as a code change.

regards,
dan carpenter

diff --git a/pre-process.c b/pre-process.c
index 34b21ff..d3ae7a0 100644
--- a/pre-process.c
+++ b/pre-process.c
@@ -154,7 +154,8 @@ static int expand_one_symbol(struct token **list)
 		return expand(list, sym);
 	}
 	if (token->ident == &__LINE___ident) {
-		replace_with_integer(token, token->pos.line);
+//		replace_with_integer(token, token->pos.line);
+		replace_with_integer(token, 12345);
 	} else if (token->ident == &__FILE___ident) {
 		replace_with_string(token, stream_name(token->pos.stream));
 	} else if (token->ident == &__DATE___ident) {
