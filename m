Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968450Ab0B0OqC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 09:46:02 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:52245 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968433Ab0B0Op7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 09:45:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ooo0nKYw2LbIZOp7d8nz0LvCd5svHLikrzMOk5LxHeX48Qgywy+NoNt9LlNx1FiMh0
         kJ1pLDWpLthId/3m3QRrTWx1TXb5IsXFHZubauYrptY5R/xzpECraivCSks2Peels3mY
         J7Q3vfIlrnQvGAaKXNup9CskAC7258F7Fci9c=
MIME-Version: 1.0
In-Reply-To: <20100226221100.GA22352@kroah.com>
References: <20100217130604.16008.86393.stgit@localhost.localdomain>
	 <20100226221100.GA22352@kroah.com>
Date: Sat, 27 Feb 2010 09:45:57 -0500
Message-ID: <969d87001002270645v4b958f91vee0c0868d665c06b@mail.gmail.com>
Subject: Re: [PATCH 1/5] tty: Add a function to insert a string of characters 
	with the same flag
From: Christopher Curtis <ccurtis0@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 5:11 PM, Greg KH <greg@kroah.com> wrote:
>
> On Wed, Feb 17, 2010 at 01:06:30PM +0000, Alan Cox wrote:
> > The USB drivers often want to insert a series of bytes all with the same
> > flag set - provide a helper for this case.
> >
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> > ---
> >
> >  drivers/char/tty_buffer.c |   12 +++++++-----
> >  include/linux/tty_flip.h  |    7 ++++++-
> >  2 files changed, 13 insertions(+), 6 deletions(-)
> >
> >
> > diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
> > index 8402eda..af8d977 100644
> > --- a/drivers/char/tty_buffer.c
> > +++ b/drivers/char/tty_buffer.c
> > @@ -231,9 +231,10 @@ int tty_buffer_request_room(struct tty_struct *tty, size_t size)
> >  EXPORT_SYMBOL_GPL(tty_buffer_request_room);
> >
> >  /**
> > - *   tty_insert_flip_string  -       Add characters to the tty buffer
> > + *   tty_insert_flip_string_fixed_flag - Add characters to the tty buffer
> >   *   @tty: tty structure
> >   *   @chars: characters
> > + *   @flag: flag value for each character
> >   *   @size: size
> >   *
> >   *   Queue a series of bytes to the tty buffering. All the characters
> > @@ -242,18 +243,19 @@ EXPORT_SYMBOL_GPL(tty_buffer_request_room);
> >   *   Locking: Called functions may take tty->buf.lock
> >   */
> >
> > -int tty_insert_flip_string(struct tty_struct *tty, const unsigned char *chars,
> > -                             size_t size)
> > +int tty_insert_flip_string_fixed_flag(struct tty_struct *tty,
> > +             const unsigned char *chars, char flag, size_t size)
> >  {
> >       int copied = 0;
> >       do {
> > +             int goal = min(size - copied, TTY_BUFFER_PAGE);
>
> This variable isn't used in this function.
>
> >               int space = tty_buffer_request_room(tty, goal);

It is used on the next line; it would appear to be a local scope alias
for some other 'goal'...?

Chris
