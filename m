Return-Path: <linux-kernel-owner+w=401wt.eu-S935883AbYD1UTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935883AbYD1UTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934190AbYD1UTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:19:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:24002 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934069AbYD1UT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:19:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=P0FWYT0Olws2HTgqrVmCv62EfNv9eenQvmEYwafVii/Jodj474v+FMzkTYK3qfA5iidRjVQxh2q5dJnsuxhQ//LrCFgcm/jCjUhutjJdXM9ZcC2kV2LyEZo2t+CoWHIz2s9AxQZdA0k02ZWHTHwcQ4WtyhhGIhYeXfY7sdjTpUM=
Date: Mon, 28 Apr 2008 16:19:25 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Stas Sergeev <stsp@aknet.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Takashi Iwai <tiwai@suse.de>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>,
       Michael Opdenacker <michael@free-electrons.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] pcspkr: fix dependancies
Message-ID: <20080428161544.ZZRA012@mailhub.coreip.homeip.net>
References: <4813476A.7000705@aknet.ru> <200804261918.14711.dtor-oss@comcast.net> <4813BD39.1080105@aknet.ru> <20080427042331.GB29127@anvil.corenet.prv> <481626B6.5040207@aknet.ru> <20080428155811.ZZRA012@mailhub.coreip.homeip.net> <20080428201225.GB18135@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428201225.GB18135@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 10:12:25PM +0200, Sam Ravnborg wrote:
> On Mon, Apr 28, 2008 at 03:58:56PM -0400, Dmitry Torokhov wrote:
> > On Mon, Apr 28, 2008 at 11:34:14PM +0400, Stas Sergeev wrote:
> > > Hello.
> > > 
> > > Dmitry Torokhov wrote:
> > > > It looks like the change was introduced by commit
> > > > 67926892ef7a7fbc76de607120d44416019fdf07
> > > Indeed. But the log message
> > > http://www.mail-archive.com/git-commits-head@vger.kernel.org/msg36026.html
> > > doesn't seem to specify the reason
> > > for the change, so this doesn't
> > > clarify a thing, unfortunately.
> > > 
> > > > I think that we should register devices even if there is no driver in
> > > > the kernel for it because driver may be compiled at later time or be out
> > > > of tree. Adding patch author and other people that signed off the patch
> > > > to CC...
> > > Since there seem to be no objections,
> > > would you mind adding the patch to your
> > > git tree? Or who should that be?
> > 
> > I try to stay within drivers/input boundaries ;) Ingo I think is the
> > person you need.
> If you google you will find a long thread about this patch.
> It is all about saving memory for embedded platforms.
> No need to have the driver if there is no speaker on the board.
> 

The patch does it backwards though - it disables platform device if
there is no driver. We don't stop enumerating PCI devices if some of
them don't have a driver for them, do we? The arch code should not
create the device if it knows that the boards does not have it.

-- 
Dmitry
