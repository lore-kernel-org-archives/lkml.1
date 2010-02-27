Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030734Ab0B0TcM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 14:32:12 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45741 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030715Ab0B0TcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 14:32:10 -0500
Date: Sat, 27 Feb 2010 19:32:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/5] tty: Add a function to insert a string of
 characters with the same flag
Message-ID: <20100227193233.0aad1e5e@lxorguk.ukuu.org.uk>
In-Reply-To: <20100226221100.GA22352@kroah.com>
References: <20100217130604.16008.86393.stgit@localhost.localdomain>
	<20100226221100.GA22352@kroah.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was it really the 17th I sent the second set out - apparently so - so
ignore the first email, this is the correct patch set.

> > +int tty_insert_flip_string_fixed_flag(struct tty_struct *tty,
> > +		const unsigned char *chars, char flag, size_t size)
> >  {
> >  	int copied = 0;
> >  	do {
> > +		int goal = min(size - copied, TTY_BUFFER_PAGE);
> 
> This variable isn't used in this function.
> 
> >  		int space = tty_buffer_request_room(tty, goal);

Its used here. The logic basically is

goal =  {	I want a buffer to hold "size - copied" 
	{	I want it to fit in one page

space = 	what I get back

we copy space and move on based on what we get back, so it looks correct
to me.

> >  		memcpy(tb->char_buf_ptr + tb->used, chars, space);
> > -		memset(tb->flag_buf_ptr + tb->used, TTY_NORMAL, space);
> > +		memset(tb->flag_buf_ptr + tb->used, flag, space);
> 
> Should you have "goal" here instead of "space"?

No because we could ask for say 500 and get 250 back, we then want to
copy 250.


Alan
