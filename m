Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbYK2W4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbYK2W4H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 17:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbYK2Wzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 17:55:37 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:30466 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752971AbYK2WzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 17:55:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=HahncOU9HQXT4R1ZZj/Gb8cjKajx8jANnXifgqN6wXBUUnYxsNg715/e5U1SgGQpv0opt2/QQbrJyEsnmieVr6g54bRAI61tXT5bvhPSCfaT5lQJpiZgngHKEtkIx/u3Nt2ukPFSxolci/KAkM11OGv2snL09qFXe5OhCt2pVm4=  ;
X-YMail-OSG: XdKLqEYVM1kD91b_h.zeyDUG0bNhECoYhssmPEhbkRtI2WGehR_vjow89d6S24YniSlFJjXRi0Q5t3XZv0NEZLTgqtOy8lc62vj8WN8Aqkjh8DeFJMDI.Q4Ky9LcFFlBuMYUPitth1mPxDGLgrMNXC06PUSAgxFb0FzbjHrJe_ozjnsYPB.JJ8vH8XxK
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Sam Ravnborg <sam@ravnborg.org>, Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Date: Sat, 29 Nov 2008 14:48:51 -0800
User-Agent: KMail/1.9.10
Cc: Eric Miao <eric.y.miao@gmail.com>, Jean Delvare <khali@linux-fr.org>,
       Eric Miao <eric.miao@marvell.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>, Ben Gardner <bgardner@wabtec.com>,
       Greg KH <greg@kroah.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com> <45a44e480811252151q54580e07xfa73d69596fbfaac@mail.gmail.com> <20081127200102.GB20443@uranus.ravnborg.org>
In-Reply-To: <20081127200102.GB20443@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811291448.52483.david-b@pacbell.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2008, Sam Ravnborg wrote:
> > > So my "is it generic enough" question is more at the level of "Are
> > > there enough Linux systems that need this sort of thing to justify
> > > generic support?".  I happen not to have come across the need for
> > > such ganged access from Linux (yet).  Whereas I've yet to use non-x86
> > > Linux systems that don't need to manipulate individual GPIO pins...
> > 
> > I have come across the following scenarios where a bus set of gpio is useful:
> > - Broadsheet E-Ink controller (uses 16-bit data bus over GPIO)
> >   framebuffer device (this patch is for this)
> > - Apollo/Hecuba E-Ink controller (uses 8-bit data bus over GPIO)
> >   framebuffer device
> > - 8-bit parallel IO matrix LCD controllers, such as the Samsung KS108,
> >   also Hitachi, etc

All of those can also be handled with traditional parallel data
busses too, of course.  Are you saying you've seen these used
with Linux systems?  Enough to justify generic support?

I've certainly seen how some of those LCD controllers, graphical
or character based, work with microcontrollers.  They're very
widely available too ... so I can imagine various uClinux systems
have one hooked up.  Most of the Linux system hookups I've happened
across use USB or serial links (e.g. the crystalfontz.com stuff)
since modern PCs are severely GPIO-deprived.

Another example where ganged access might help is keypad matrices.


> We have such a system at work. And we need fast acces to the gpio pins
> when updating the LCD.
> I have not written/looked to deep at the code I just recall it was
> a bit messy and not something I would be proud of submitting to any ML.

Often times such messiness is more because the code never got
cleaned up, because it's kind of a one-off to support particular
boards.

You could say that the gpiolib implementation framework got its
start, in part, as a way to unclutter some kernel trees that
had way too much one-off stuff like that.  ;)

- Dave
