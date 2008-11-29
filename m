Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbYK2WzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbYK2WzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 17:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYK2WzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 17:55:09 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:30437 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752730AbYK2WzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 17:55:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MtXx7Xt9J8OU6Am/0FuSmIPFDEns0SDbraIYDZzqiLFXR8xBQX2VJVOvUZ0FFIf0rUq1E6c50qU7KN4vWJCgYSxOYbU9bjRkkOrM+t10EI3qCFsyY0UjenDEyGXT9uFl9N7wiQf4oux6IuYaHKEdk7WTbg6iqfNMpmocFWFjjik=  ;
X-YMail-OSG: l_locpwVM1lDtbbcBLLTpO3KIzIcll87_1sh7pX5QnDYvz7WOhJnqx4YCkcQm3aQO4pwJdM1xXMnz.XI8CBydqtyIJKNGce1YGLUM5M.fE1Z1PwFUOMIAnPtCnsNH3IXYE8-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2] v4l2_device/v4l2_subdev: final (?) version
Date: Sat, 29 Nov 2008 14:22:19 -0800
User-Agent: KMail/1.9.10
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       linux-kernel@vger.kernel.org,
       Laurent Pinchart <laurent.pinchart@skynet.be>
References: <200811291852.41794.hverkuil@xs4all.nl> <200811291220.47542.david-b@pacbell.net> <200811292246.20338.hverkuil@xs4all.nl>
In-Reply-To: <200811292246.20338.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200811291422.20155.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 November 2008, Hans Verkuil wrote:
> > > +void v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
> > > +{ 
> > > +       BUG_ON(!dev || !v4l2_dev || dev_get_drvdata(dev));
> >
> > Ouch.  Better to return -EINVAL, like most register() calls,
> > than *ever* use a BUG_ON() for bad parameters.  Same applies
> > every other place you use BUG_ON, from a quick scan ...
> 
> Are there some documented guidelines on when to use BUG_ON?

Maybe there should be.  I know I've seen flames from Linus on
the topic.  Basically, treat it like a panic() where the system
must stop operation lest it catch fire or scribble all over the
(not-backed-up) disk ... if the system can keep running sanely,
then BUG() and friends are inappropriate.


> I see it used in other places in this way.

I tend to submit patches fixing bugs like that, when I have time.


> My reasoning was that returning an  
> error makes sense if external causes can result in an error, but this 
> test is more the equivalent of an assert(), i.e. catching a programming 
> bug early.

In which case a WARN() is better.  But in most cases I wouldn't
even do that.  The kernel's design center is closer to "run
robustly" than "make developers' lives easier".  Programmers
who don't check return values for critical operations like
registering core resources deserve what they get.  And if you
want to nudge them, the __must_check annotation helps catch
such goofage even earlier:  compile time, not run time.

- Dave

