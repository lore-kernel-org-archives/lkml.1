Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbYILPgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbYILPgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 11:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYILPgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 11:36:36 -0400
Received: from web50606.mail.re2.yahoo.com ([206.190.38.93]:45416 "HELO
	web50606.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752150AbYILPgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 11:36:36 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2008 11:36:35 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=5nK5dwL/9Q0lPf94xEoD/ZnYSkKRmdCO2LkAPJqAmkvVFk1fZWagJL8OOcYFeCxzWOwDAZQwnp6N0a4USeH0MD1PvowOzDggy1OEjIX7zviI6Hwb+npbHWcVc6X3ogHBgJXJTgymBjEsZeYr/v8h5vLwAo98icJyZrbgHZHe4a8=;
X-YMail-OSG: E74Dg3IVM1lccvvHf_Lv4m0_Lx5M_rYrQh4BHor56UNoX7sphzjBgj_j2HOy_NL2BVQnQOQ.BAA83zkzPFZfAHep38jhDG0cLMVYOb_Y4.ekk2Ic0uzgbRBwD1XV62rH.rfYv_Po2OQWZng5gliW4JU-
X-Mailer: YahooMailWebService/0.7.218.2
Date: Fri, 12 Sep 2008 08:29:51 -0700 (PDT)
From: marty <martyleisner@yahoo.com>
Subject: Re: FW: [linux-pm] select with timeout across S3
To: "Leisner, Martin" <Martin.Leisner@xerox.com>, Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
In-Reply-To: <20080911092408.GA14503@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <739522.18279.qm@web50606.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't see a behavior change in the current kernels.

Select(2) timeouts only count the time the machine is up -- not sleeping...

I had a patch for 2.6.20 that I tried (it modified schedule_timeout) -- 
it didn't do anything useful in 2.6.27-rc5.

marty


--- On Thu, 9/11/08, Pavel Machek <pavel@suse.cz> wrote:

> From: Pavel Machek <pavel@suse.cz>
> Subject: Re: FW: [linux-pm] select with timeout across S3
> To: "Leisner, Martin" <Martin.Leisner@xerox.com>
> Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org, martyleisner@yahoo.com
> Date: Thursday, September 11, 2008, 5:24 AM
> On Thu 2008-09-11 02:17:10, Leisner, Martin wrote:
> > Hi,
> > 
> > I finally got 2.6.27-rc5 running...no change in my
> test program...
> > 
> > I'm going to look at the patches we're using
> for 2.4.20/2.6.20...
> 
> So the bug is still there, or did 2.6.27-rc5 magically
> solve the problem?
> 
> > marty
> > 
> > 
> > -----Original Message-----
> > From: Pavel Machek [mailto:pavel@suse.cz]
> > Sent: Mon 9/1/2008 2:25 AM
> > To: Leisner, Martin
> > Cc: linux-kernel@vger.kernel.org;
> linux-pm@lists.linux-foundation.org
> > Subject: Re: FW: [linux-pm] select with timeout across
> S3
> >  
> > Hi!
> > 
> > > The behavior of linux (in both 2.4.x and 2.6.x)
> is when the processor
> > > sleeps, timeouts on select don't take into
> account the sleep time,
> > > only the run time.
> > > 
> > > For example, this program should pause for 10
> minutes -- however
> > > if we go into S3 in the middle its pausing for
> (10 minutes + time in
> > > S3)
> > > 
> > > I saw this on both 2.6.20 and 2.6.22...
> > 
> > Can you test this on 2.6.27-rc? We did have some fixes
> in that
> > area....
> > 
> > 							Pavel
> > 
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures)
> http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


      
