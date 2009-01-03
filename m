Return-Path: <linux-kernel-owner+w=401wt.eu-S932364AbZACDDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbZACDDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 22:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758762AbZACDD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 22:03:28 -0500
Received: from phunq.net ([64.81.85.152]:44403 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758662AbZACDD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 22:03:27 -0500
From: Daniel Phillips <phillips@phunq.net>
To: tux3@tux3.org
Subject: Re: [Tux3] Tux3 report: A Golden Copy
Date: Fri, 2 Jan 2009 19:03:24 -0800
User-Agent: KMail/1.9.5
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200812301935.49303.phillips@phunq.net> <200901021719.26680.phillips@phunq.net> <495EC040.2070905@gmail.com>
In-Reply-To: <495EC040.2070905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901021903.24189.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 January 2009 17:32, Justin P. Mattock wrote:
> Daniel Phillips wrote:
> > On Friday 02 January 2009 15:11, Justin P. Mattock wrote:
> >   
> >> The game that came to mind when I first
> >> heard of tux3(I had to google a bit to find the name)
> >> was tux racer.  :^)
> >> quick question:
> >> what is the state for security file labeling for
> >> SELinux on this filesystem?
> >
> > There is a lot of interest in security labels.  You are not the first
> > to ask.
> >
> > Tux3 variable inode attributes are ideal for implementing security 
> > labels efficiently, way more lightweight than extended attributes.  
> > Otherwise, we would like to know exactly what people want.
> >
> > Regards,
> >
> > Daniel
> >   
> thats probably one of the main areas of
> interest that I have in filesystems,
> the ability to run a policy etc..
> As for what people want, thats tough
> to say, my guess would be file corruption,
> then probably security etc..

I meant, what do people specifically want in security.  For SELinux,
probably the most important issue is efficient extended attribute
support, which Tux3 has a pretty good start on:

   http://lwn.net/Articles/300416/
   Tux3 gets a high speed atom smasher

One feature we are kicking around to make life easier for SELinux:
sometimes the filesystem can run while SELinux is not running, and
security labels will be wrong when SELinux re-enters the picture.  We
have in mind to provide a persistent log of filesystem events that the
security system can attach to on startup and find out what went on in
its absence.

And it might be nice to provide direct access to Tux3's variable inode
attributes as I mentioned, letting the security system bypass the
heavyweight xattr paths.  My thinking is, the more direct the security
path, the more likely it is to be secure, and the less overhead it has,
the more likely people are to use it.  Somebody might want to play with
this idea and see if it makes a difference.

Of course, these features are secondary to base filesystem solidity,
which will be the main focus for the next little while, but now is the
time to talk about what you want, in case the design can be adjusted to
make it more practical.

More security wishes go here: ->[___________________]<-

Regards,

Daniel
