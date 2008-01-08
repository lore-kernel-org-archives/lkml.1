Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbYAHUQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbYAHUQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYAHUQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:16:08 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:59324 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbYAHUQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:16:07 -0500
Date: Tue, 8 Jan 2008 13:16:06 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, gorcunov@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080108201606.GJ16309@parisc-linux.org>
References: <20080108164015.GC31504@one.firstfloor.org> <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com> <20080108200044.GI16309@parisc-linux.org> <4d8e3fd30801081203l636c5923j7965efaa9c121c56@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8e3fd30801081203l636c5923j7965efaa9c121c56@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 09:03:13PM +0100, Paolo Ciarrocchi wrote:
> On Jan 8, 2008 9:00 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> > On Tue, Jan 08, 2008 at 08:58:04PM +0100, Paolo Ciarrocchi wrote:
> > > -static const struct file_operations rtc_fops = {
> > > +static long rtc_fioctl(struct file_operations rtc_fops)
> > > +{
> > > +     lock_kernel();
> > >       .owner          = THIS_MODULE,
> >
> > You should probably restrict yourself to files that you can at least
> > compile ...
> 
> Yes of course, I've been silly in didn't verify whether the file compile
> but I would appreciate to know whether I'm on the right track or not.

Well ... you're not.

You've deleted the definition of rtc_fops for no reason I can tell.

You put an unlock_kernel() on every place that invokes break;.  You
should instead have put an unlock_kernel() before every return;.

You needed to put a lock_kernel() at the beginning of rtc_ioctl().

You needed to adjust the prototype of rtc_ioctl().

Honestly, if your C skills are as weak as they seem to be, you may be
better off trying to gain experience with some other project -- the
patch you sent appeared to be simple cargo-cult programming, and we
don't need that kind of contribution.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
