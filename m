Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879AbZLKFND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbZLKFND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:13:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZLKFNC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:13:02 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:33224 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752598AbZLKFNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:13:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OVP9Sa+nW4SS4XDAvPym2SatX6DEY8NnnspFnRYzTrI/s3eivTdsMPUCaZFCfAua1naKSEvTN1ipGjvFgj9ygC1iRdgIQQ+KjPZaiRg4XYcjh4nilA6B5roxhUbyKywz6DJfnwnBs4OwhnSKBXfQNPf3DMahwm09VDl9CDltnNw=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: fZY1NksVM1mhjuIRODORhjeCs4z4.CSgsdOyeInSxp_ecYfq9jEGidYNax9YhGzfCBrjpGFnTAiBL2gJPCJWq0VG9jvp3oTZa6rjLLzZpyYF5xWWWkTwXkwlAxoWXoz4apvcowO0CluXxsi53oFJ997dfq9adJbROT7YKA_WEFYoCps9AklpDDSwJ8u1KrB5.kTVZLPjVUDyigF5jYl4pzkKs5rSkfTVHJxj_qctDLFHcX.0sSn3Xab8x.eKHADz
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 3/3] gpiolib: use chip->names for symlinks, always use gpioN for device names
Date: Thu, 10 Dec 2009 21:13:06 -0800
User-Agent: KMail/1.9.10
Cc: Jani Nikula <ext-jani.1.nikula@nokia.com>, linux-kernel@vger.kernel.org,
       dsilvers@simtec.co.uk, ben@simtec.co.uk, Artem.Bityutskiy@nokia.com,
       akpm@linux-foundation.org
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> <200912102013.59329.david-b@pacbell.net> <20091211043849.GA18007@suse.de>
In-Reply-To: <20091211043849.GA18007@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912102113.06973.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 December 2009, Greg KH wrote:
> On Thu, Dec 10, 2009 at 08:13:58PM -0800, David Brownell wrote:
> > On Thursday 10 December 2009, Greg KH wrote:
> > > 
> > > > IMO a "good" solution in this space needs to accept that
> > > > those names are not going to be globally unique ... but
> > > > that they'll be unique within some context, of necessity.
> > > > 
> > > > If Greg doesn't want to see those names under classes,
> > > > so be it ... but where should they then appear?
> > > 
> > > As a sysfs file within the device directory called 'name'? ?Then just
> > > grep through the tree to find the right device, that also handles
> > > duplicates just fine, right?
> > 
> > I want a concrete example.  Those chip->names things don't
> > seem helpful to me though...
> > 
> > ...
> 
> Um, I really don't know, as I don't know the GPIO subsystem, nor why you
> all have this problem in the first place :)

Maybe Jani can provide a more concrete example.


> I also find it funny that you think changing the kernel is easier than
> userspace, that's a strange situation.

I don't recall saying that.  :)

It's a case of kernel having access to system data that's not
otherwise exported to userspace.  It knows how the various bits
of hardware fit together ... and in this case wants to export
associations between some GPIOs and some other hardware.  Given
that, userspace can pick things up.

 
> Anyway, I assumed that you already have a struct device for the GPIO
> devices, right?  Put it in there was what I was thinking, but as I don't
> understand your current layout, I really don't know.

There are gpio_chip devices, for a set of GPIOs.  But not for
the individual GPIOs.


> > I confess I'd still think a symlink from that directory
> > to the real GPIO would be easier to work with...
> 
> No, don't do that, no symlinks from a class please.

I didn't catch a reason for that request... could you
explain that?

- Dave

