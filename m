Return-Path: <linux-kernel-owner+w=401wt.eu-S932281AbXHCOiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbXHCOiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 10:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762168AbXHCOiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 10:38:00 -0400
Received: from smtp114.sbc.mail.re2.yahoo.com ([68.142.229.91]:41808 "HELO
	smtp114.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762267AbXHCOh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 10:37:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PN2cFv2E5mXuoJdQ9mH3rQ8xhBrBnAZ4+yx7/1FFRBrq3wHVlqHWMER0bL7qq4ReSVUIikAF5KSj8zOUzGKESai2ue/bHqDRq01DafXayKZGLpwu2+IRRuXh2q11aGFR3fNKNmOf9XQhOLGtF/JBPD19zl8/QbLcU+tXDsymjV8=  ;
X-YMail-OSG: l3Wnj3YVM1nAjTxqdLtQfnaom.FozwWpa7BkkCXpUmmB6YckUSLP1PRpI9yStLfUdHTTa23VjcbthrYs0TW6X1bEynRV7zeYUPlIGlmyMrqe91xHzKAScnk78Mh5j58Plc8nEIkQFdSQSdo-
From: David Brownell <david-b@pacbell.net>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default on certain device classes
Date: Fri, 3 Aug 2007 07:37:55 -0700
User-Agent: KMail/1.9.6
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       Rogan Dawes <lists@dawes.za.net>, Oliver Neukum <oliver@neukum.org>,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org> <200708030701.11404.david-b@pacbell.net> <20070803140909.GA19245@srcf.ucam.org>
In-Reply-To: <20070803140909.GA19245@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708030737.56316.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 August 2007, Matthew Garrett wrote:
> On Fri, Aug 03, 2007 at 07:01:11AM -0700, David Brownell wrote:
> 
> > Which is, as I pointed out, the wrong response.  Desktoppy
> > people should be making their tools do more intelligent things
> > with new USB devices they see ... like updating databases of
> > broken devices, and configuring *this* system to know that of
> > the devices it regularly deals with, this handful is broken.
> 
> Popping up a box saying "Is your device broken?" isn't good UI. 

Which is why I didn't suggest doing that, of course.  The only
one making that kind of straw man argument seems to be you.


> > > But while this is still a likely probability, the chances are no 
> > > distribution is going to ship with CONFIG_USB_SUSPEND enabled.
> > 
> > So you're saying all the distros want to make PM problems worse?
> 
> No. But given a choice between working hardware or marginally better 
> runtime PM, they're going to choose working hardware.

However, you've strongly implied that you want to see a short term
patch, of the type which will (as Rogan Dawes implied) prevent solving
the problem in the long term ...


> > And that with all the other desktoppy stuff they're doing, not one
> > of them is willing to help make things better?
> 
> This patch is exactly that - a way of getting most of the benefits of 
> autosuspend without any real probability of breaking hardware. If you 
> mean "Are the distributions willing to pop up dialogs asking users to 
> start caring about obscure aspects of the USB spec", then I don't think 
> that's actually making things better.

Evidently you were reading someone else's message and blaming its
content on me ... since the focus of what I wrote was having a
database *OUTSIDE THE KERNEL* which would obviate the need for
any user interaction in most cases.

If I were to describe any dialog users would see, it would be more
like "I don't recognize this device, help me set it up right...".
As with music CDs, that help might update the database for the next
person.  (Assuming this were done well, of course.)


> > Pardon me if I want to hear distro vendors agree with you before I
> > believe that.
> 
> I'm speaking as part of the Ubuntu kernel team, and I've been discussing 
> this with Fedora people.

And has the discussion included the userspace people?  (I don't
know how Ubuntu or Fedora folk structure such platform-scope
tasks.  By inference, there's not enough cross-pollination...)

Speaking of which, what's this /dev/bus/usb/* crap on Ubuntu?
I had to undo all that on my Feisty system before any normal
/proc/bus/usb stuff would work again.


> > > Breaking  
> > > people's hardware (even if, at a fundamental level, it's the hardware 
> > > that's broken) generally irritates users - and I suspect that the users 
> > > it'll irritate the most are the ones who won't report it to LKML.
> >
> > Having a laptop drain its battery an hour before it needs to is
> > also irritating.  (As are the extortionate prices for each model's
> > unique batteries, but that's a different issue.)
> 
> You commonly run a laptop off battery while having a printer plugged in?

Unfortunately I need to run laptop off AC since its battery life is
painfully short, and since Linux behaves so incredibly rudely when
the battery power goes down to almost-zero:  it lets it go to zero
rather than hibernating.  (And doesn't automatically enter suspend
when it idles, either...)

Note by the way that if you were -- for the sake of argument -- accept
my premise that this should all be handled in userspace ... it's very
easy to make userspace code do what you want.  It doesn't need to be
done inside the kernel.

- Dave
