Return-Path: <linux-kernel-owner+w=401wt.eu-S1760817AbZADUUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760817AbZADUUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 15:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbZADUTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 15:19:24 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43583
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbZADUTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 15:19:19 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Sun, 4 Jan 2009 14:19:11 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Matthieu CASTET <matthieu.castet@parrot.com>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <200901020207.30359.rob@landley.net> <200901031945.35163.rob@landley.net> <20090104080931.GA31198@uranus.ravnborg.org>
In-Reply-To: <20090104080931.GA31198@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901041419.11569.rob@landley.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 January 2009 02:09:31 Sam Ravnborg wrote:
> On Sat, Jan 03, 2009 at 07:45:34PM -0600, Rob Landley wrote:
> > Since you're turning down an existing patch in favor of a theoretical
> > patch, I assume you have plans to do this yourself?
>
> If noone else beats me I will do so - yes.

Ok.

> > >   And this must be in a single program that can process
> > >   all headers in one go so the install process becomes so fast
> > >   that we do not worry about if it was done before or not.
> > >   Then we can avoid all the .* files in the directory
> > >   where we isntall the headers.
> >
> > What if they run out of disk space halfway through writing a file and
> > thus it creates a short file (or a 0 length file where the dentry was
> > created but no blocks could be allocated for the write)?
>
> Then they fail and make will know. Then may leave a file or 100
> but it still failed. At next run everything will be done right
> assuming the culprint has been fixed.

Ok, so the important thing is propagating failures up to the exit code, then?

When making this patch I hit a problem that the exit code of "unifdef" seems 
to depend on whether it found anything to remove within the file it was 
processing, so when I changed the caller to actually care about its exit code 
it spontaneously aborted.

Fixing that probably does require changing unifdef.c.

> > I can try to make the shell version more readable, and more powerful. 
> > It's already noticeably faster than the perl version.  I have no
> > objections to making unifdef do all of this, I just haven't got any
> > interest either.
>
> I have no interest in merging a shell version.

*shrug*  Ok.  I await your C version, and have a workable patch meeting my own 
needs in the meantime.

Thanks,

Rob

