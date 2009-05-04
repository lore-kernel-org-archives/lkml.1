Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbZEDV4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbZEDV4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 17:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbZEDV41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 17:56:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44331 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701AbZEDV40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 17:56:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: compat ioctl32 for /dev/snapshot?
Date: Mon, 4 May 2009 23:55:46 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       "Linux-kernel" <linux-kernel@vger.kernel.org>
References: <49FEB572.4010909@msgid.tls.msk.ru> <49FEC98E.4050906@msgid.tls.msk.ru> <20090504111243.GH23223@one.firstfloor.org>
In-Reply-To: <20090504111243.GH23223@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905042355.47109.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 May 2009, Andi Kleen wrote:
> On Mon, May 04, 2009 at 02:55:10PM +0400, Michael Tokarev wrote:
> > Andi Kleen wrote:
> > >Michael Tokarev <mjt@tls.msk.ru> writes:
> > >
> > >>Is there any reason why 32-bit uswsusp &Friends does not work
> > >>on 64bits kernel?
> > >>
> > >>For one, 32bits s2disk produces the following when trying to
> > >>suspend:
> > >>
> > >> ioctl32(s2disk:4134): Unknown cmd fd(4) cmd(400c330d){t:'3';sz:12} 
> > >> arg(ff853554) on /dev/snapshot
> > >> ioctl32(s2disk:4134): Unknown cmd fd(4) cmd(4004330a){t:'3';sz:4} 
> > >> arg(00000805) on /dev/snapshot
> > >>
> > []
> > >It's probably just that nobody has written the code yet. In general all
> > >missing compat_ioctls are bugs.
> > 
> > Oh well.
> > 
> > Is the following patch ok?  I just pulled all the SNAPSHOT_* stuff from
> 
> You should ask Rafael (cc'ed) who maintains that code.

Thanks for CCing me. :-)

In fact I don't think the 32-bit user space will work with 64-bit kernels as is
in this particular case, because of the different pointer size.

Having a quick look at the code (I don't remember the details right now)
I think most probably it could be modified to handle this case too, but I'm not
really sure.

Best,
Rafael
