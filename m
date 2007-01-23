Return-Path: <linux-kernel-owner+w=401wt.eu-S933136AbXAWTeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136AbXAWTeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 14:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933137AbXAWTeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 14:34:13 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:9100 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136AbXAWTeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 14:34:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NgRdCH904IUMwun0J7osnlw3HcKygCOk7saCwYKNouMZICIJFhzqPhSehCbqrNEWCqIuwQ8gqWeGeP+LGBUJol6lLf/0SwUMpT28YdKqADmj/VXJ9C51vxx9Ij6SjE9IYP3aqZex+muehN6rUuBQeTEr6BtQR33PM6kdHfOPD4Y=
Message-ID: <7b69d1470701231134k4e3e8a4dj2b95a230fa3da81c@mail.gmail.com>
Date: Tue, 23 Jan 2007 13:34:11 -0600
From: "Scott Preece" <sepreece@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
Cc: "Alessandro Di Marco" <dmr@gmx.it>, linux-kernel@vger.kernel.org,
       vojtech@suse.cz
In-Reply-To: <20070123163442.GA18662@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <877ivkrv5s.fsf@gmx.it> <20070119101103.GA5730@ucw.cz>
	 <877ivfi60i.fsf@gmx.it> <20070123094114.GE6033@ucw.cz>
	 <87wt3dhlte.fsf@gmx.it> <20070123163442.GA18662@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/07, Pavel Machek <pavel@ucw.cz> wrote:
> Hi1
> ...
> >
>
> >    But I still believe it can be out.
> >
> > Do you believe it could be a user-space daemon or what?
>
> Yes, what prevents userspace daemon watching /dev/input/event* to
> provide this functionality?
>                                                                         Pavel
---

One possible argument is to allow integrating "input-like" user events
with other kinds of system-level events that you might want to have
treated like user activity. For instance, our definition of user
activity includes: button presses, opening-closing the cover (on a
phone), and plugging in or removing memory cards, accessories, or
cables. We actually use a mix of kernel and user-space monitoring,
today, but would prefer an integrated monitor.

A user-space monitor also has more opportunity for races - for
instance, deciding that the inactivity timeout has occurred between
the time that the user does something and the time that the kernel
gets a notification up to user space.

My own hot button is making sure that the definition of what
constitutes user activity is managed in exactly one place, whether in
the kernel or not. My naive model would be to put the response at user
level, but to provide a single point of definition in the kernel (say,
/dev/useractivity or the equivalent) that the user-level daemon could
listen to.

scott
