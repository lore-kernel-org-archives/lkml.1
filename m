Return-Path: <linux-kernel-owner+w=401wt.eu-S1760043AbXGYXeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043AbXGYXeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 19:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbXGYXeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 19:34:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:49606 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbXGYXd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 19:33:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bFH+r4XkzuQwttc/SDxRrcSUxBcIyHxkQcCqdLx9Zsb5LUeLsIfA4JTloCc52JrAkLxeZa7M1x7dA3J7kq7K+bFyvU0/QA/3HjbvPxOYCH0qq1LPkglT4bWMLYftlgngn4ZjNNdqrtoX1V8OFtB4Hdbj7sBuq/ndnt8JIhTCjWY=
Subject: Re: Problems with framebuffer in 2.6.22-git17
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: Adrian McMenamin <adrianmcmenamin@gmail.com>, linux-kernel@vger.kernel.org,
       lethal@users.sourceforge.net
In-Reply-To: <8b67d60707241445l2764d9f1odb72848342135048@mail.gmail.com>
References: <92a12cdb0707221141i4398d6fdxa7994c5f1f809b0a@mail.gmail.com>
	 <1185146563.6370.8.camel@daplas>
	 <8b67d60707241445l2764d9f1odb72848342135048@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 07:33:53 +0800
Message-Id: <1185406433.5046.23.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 22:45 +0100, Adrian McMenamin wrote:
> On 23/07/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> > On Sun, 2007-07-22 at 19:41 +0100, Adrian McMenamin wrote:
> > > I ma having problems with the pvr2 fb on the Dreamcast in 2.6.22-git17
> > > - when the code is executed it appears to lock the Dreamcast up.
> > >
> > > The problem seems to be:
> > >
> > >  fb_notifier_call_chain(FB_EVENT_FB_REGISTERED, &event);
> > >
> > > In drivers/video/fbmem.c
> > >
> > > This hasn't been an issue before, so are there any recent changes that
> > > might have caused this?
> >
> > What's the last kernel that worked for you? Can you also post your
> > config?
> >
> > >
> > > (fb_notifier_call_chain calls a succession of stubs ending in
> > > __blocking_notifier_call_chain in kernel/sys.c)
> > >
> >
> > Try reverting commit a66ad56eb2c9644717da4d7f05f971d6786145e3.
> >
> > Tony
> >
> 
> Tony,
> 
> I have checked this a few times now, including against Paul's git as
> well as Linus's and the Dreamcast won't boot without its reversion.
> Don't know why, but it needs to be reverted until a better fix is
> available.

I'm also confused. Can you change the color depth to 32 bpp ('fbset
-depth 32')?  I'm thinking of a possible pseudo_palette overrun.

Tony 


