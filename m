Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZCXVjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZCXVjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbZCXVjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:39:21 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:33323 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZCXVjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:39:19 -0400
Date: Tue, 24 Mar 2009 22:41:18 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Stoyan Gaydarov <stoyboyker@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 12/13] [drivers/media] changed ioctls to unlocked
Message-ID: <20090324214118.GA24441@uranus.ravnborg.org>
References: <1237929168-15341-13-git-send-email-stoyboyker@gmail.com> <20090324212445.224fd377@lxorguk.ukuu.org.uk> <6d291e080903241431m3816e0a0sb55070e1d992054d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6d291e080903241431m3816e0a0sb55070e1d992054d@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 04:31:54PM -0500, Stoyan Gaydarov wrote:
> On Tue, Mar 24, 2009 at 4:24 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >
> >> -static int dabusb_ioctl (struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
> >> +static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg)
> >>  {
> >> +     lock_kernel();
> >>       pdabusb_t s = (pdabusb_t) file->private_data;
> >
> > After the variables or you'll get lots of warnings from gcc
> >
> >
> 
> Unfortunately I am not familiar with this driver and as such i was not
> sure if the variable required the lock to be accessed or not so as to
> play it safe i put it before the variable. But i can resubmit this
> patch if there are no problems.

Please do so.

It is considered better style to first decalre the variable and then later
assign it.
So this would allow you to move the assignment after the lock_kernel(),

	Sam
