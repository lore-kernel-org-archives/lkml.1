Return-Path: <linux-kernel-owner+w=401wt.eu-S932922AbXBKXkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbXBKXkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932924AbXBKXkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:40:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39483 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932922AbXBKXku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:40:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: NAK new drivers without proper power management?
Date: Mon, 12 Feb 2007 00:38:12 +0100
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <1171232786.4493.62.camel@nigel.suspend2.net> <20070211224637.GC13913@1wt.eu>
In-Reply-To: <20070211224637.GC13913@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702120038.12875.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 February 2007 23:46, Willy Tarreau wrote:
> On Mon, Feb 12, 2007 at 09:26:26AM +1100, Nigel Cunningham wrote:
> > Hi.
> > 
> > On Sun, 2007-02-11 at 22:52 +0100, Willy Tarreau wrote:
> > > On Sun, Feb 11, 2007 at 12:31:14PM -0600, Robert Hancock wrote:
> > > > Willy Tarreau wrote:
> > > > >Nigel, don't take it as a personal offense, but I think it is a very
> > > > >centric view of Linux usages. Where I work, Linux is used a lot on
> > > > >servers and appliances. It is used for mail relays, HTTP proxies,
> > > > >anti-viruses, firewalls, routers, load balancers, UTM, SSH relays,
> > > > >etc... Nobody would ever want to enable power management on those
> > > > >machines, let alone suspend which would cause a major havoc, would
> > > > >the system decide to enter suspend for any reason.
> > > > >
> > > > >Many people also have Linux on their notebooks, but as a dual-boot. You
> > > > >read the word ? "dual-boot". It means that they cleanly shutdown their
> > > > >system every time they don't use it anymore, and they won't know what
> > > > >OS they'll use next time.
> > > > >
> > > > >I've never heard anyone there complaining "oh, I'm fed up with this
> > > > >boring boot, I always have to wait 30 seconds when I need to do
> > > > >something, I wish I could suspend and resume". It is considered the
> > > > >normal way of using their PCs.
> > > > 
> > > > I think your experience is rather different than that of Joe Average 
> > > > User who doesn't frequent kernel lists, and also I think you'll find 
> > > > that for a lot of Linux laptop users that don't use supend, the reason 
> > > > is that it doesn't work reliably, quite often due to driver issues.
> > > 
> > > I would believe it if I knew people using suspend/resume on the other OS.
> > > But that's not the case either. Also, it happens that with today's RAM
> > > sizes, suspend-to-disk then resume can be several times slower than a
> > > clean fresh boot. When you have 1 GB to write at 20 MB/s, it takes 50
> > > seconds to shut down, and as much to restart. Compare this to 5-10
> > > seconds for a shutdown and 30-50 seconds for a cold boot, and it might
> > > give you another clue why there are people not interested in such a
> > > feature.

I use the suspend to disk on a regular basis, because it takes at least 3x more
time to boot and get KDE started than to resume.

> > I'm using M$ hibernation and Suspend2 to dual boot on our desktop (dtv
> > card that Linux doesn't support well yet), and I know other Suspend2
> > users doing the same. It's made earier by the fact that Suspend2 lets
> > you reboot instead of powering down.
> > 
> > As to comparing the speed with the time to boot, your estimates are way
> > out. Both will of course vary with the harddrive and cpu speeds and
> > compression qualities of the image, but with Suspend2, I'm seeing speeds
> > more in the range of 40-100MB/s, and even had a resport of 160MB/s a
> > couple of days ago. The rule of thumb I use is:
> > 
> > Run hdparm -t (or equiv) on the drive you'll be using:
> > 
> > nigel@nigel:~$ sudo hdparm -t /dev/hda
> > 
> > /dev/hda:
> >  Timing buffered disk reads:  120 MB in  3.02 seconds =  39.70 MB/sec
> > 
> > Then calculate RAM_IN_MB / 2 / HDPARM_RESULT = seconds to read/write
> > image.
> > 
> > In my case: 1024 / 2 / 39.7 = approx 12 seconds. The / 2 is because with
> > LZF compression, you normally get about 50% compression.
> > 
> > I think the mean reason some people aren't interested in suspend to disk
> > is because of myths (if you'll excuse the term) like the one you've put
> > above. Of course that values you give were more accurate for swsusp and
> > uswsusp until recently, but Suspend2 has had async I/O and compression
> > for years, so all I can really do is encourage you to try again.
> 
> Well, I agree that you give some good arguments here.
> 
> > Of course there's another factor you're not taking into account: With
> > suspending to disk, you don't have to close and reopen documents or shut
> > down and restart applications. The time to do that should be factored
> > into the non-suspend-to-disk time to compare apples with apples.
> 
> Hmm sorry, but we don't have the same usages of notebooks. For no reason
> would I keep documents open, for two reasons :
> 
>   - when I shutdown my notebook, it is to move from one customer to
>     home/company/another customer. There's no related work anyway, the
>     network will have changed and I'll have to switch nearly all of my
>     apps anyway. So using suspend just to save one reboot is not worth
>     it (for me) IMHO.
> 
>   - I would certainly not keep open documents that are on crypted FS
>     while I travel. Otherwise, it would be a total waste of time to
>     enter my passphrase everytime I need to access them ! Some might
>     argue that it would save me a lot of time, providing me with the
>     ability to type my passphrase only once a month, but that's not
>     what I'm looking for :-)
> 
> I can barely understand why one would prefer to suspend when the notebook
> does not move at all, but under the conditions above, advantages are really
> faint. I now realize that people I work with also face the same constraints,
> which can explain why they don't use such features either, whatever the OS.

Please note we're talking about the suspend to RAM here too and, arguably, the
support in drivers is more important for the suspend to RAM.

Greetings,
Rafael
