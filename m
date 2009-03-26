Return-Path: <linux-kernel-owner+w=401wt.eu-S1760118AbZCZR6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118AbZCZR6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbZCZR6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:58:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754481AbZCZR6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:58:20 -0400
Date: Thu, 26 Mar 2009 10:48:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       tytso@mit.edu, jack@suse.cz, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org, a.p.zijlstra@chello.nl, npiggin@suse.de,
       jens.axboe@oracle.com, drees76@gmail.com, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, oleg@redhat.com, roland@redhat.com
Subject: Re: relatime: update once per day patches (was: ext3 IO latency
 measurements)
Message-Id: <20090326104843.46abfaa7.akpm@linux-foundation.org>
In-Reply-To: <200903261812.09153.elendil@planet.nl>
References: <20090325123744.GK23439@duck.suse.cz>
	<alpine.LFD.2.00.0903260912270.3032@localhost.localdomain>
	<20090326092454.b74e3f96.akpm@linux-foundation.org>
	<200903261812.09153.elendil@planet.nl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 18:12:04 +0100 Frans Pop <elendil@planet.nl> wrote:

> On Thursday 26 March 2009, Andrew Morton wrote:
> > On Thu, 26 Mar 2009 09:14:28 -0700 (PDT) Linus Torvalds 
> <torvalds@linux-foundation.org> wrote:
> > > I generally agree witht he "leave policy to user space" people, but
> > > this is an area where (a) user space has shown itself to not get it
> > > right (ie people don't do even the existing relatime because distros
> > > don't) and (b) what's the alternative?
> > >
> > > > I (and others) pointed out that it would be better to implement
> > > > this as a mount option.  That suggestion was met with varying
> > > > sillinesses and that is where things stand.
> > >
> > > I'd suggest first just doing the 24 hour thing, and then, IF user
> > > space actually ever gets its act together, and people care, and they
> > > _ask_ for a mount option, that's when it's worth doing.
> >
> > We wouldn't normally just enable the new feature by default because it
> > changes kernel behaviour.  Userspace needs to be changed in some manner
> > to opt-in.  One way it's `mount -o remount', the other way it's a poke
> > in /proc.
> 
> What change are you talking about here exactly? The "change relatime to 
> have a 24 hour safeguard" of Matthes's first patch or the "enable 
> relatime by default" options in the second patch?
> 
> For the first I don't think it's that big a deal as it is a change that 
> makes the behavior of relatime safer and not riskier. Also, it's 
> something people have argued should have been part of the initial 
> functionality of relatime (it was part of the discussion back then), and 
> finally for a lot of users it's already current functionality as major 
> distros already do include the patch.
> 
> For the second, I can see your point and can understand reservations to 
> make enabling relatime a kernel config option.
> 
> Speaking exclusively for myself, I would be happy enough if only the first 
> of Matthew's patches would get accepted.
> 

Oh, the feature itself is desirable.  But the interface isn't.

- It's a magic number.  Maybe someone runs tmpwatch twice per day, or
  weekly, or...

- That's fixable by making "24" tunable, but it's still a global
  thing.  Better to make it per-fs.

- mount(8) is the standard way of tuning fs behaviour.  There's no
  need to deviate from that here.

Note that none of this involves the default setting.  With a per-mount
tunable we can still make the default for each fs be "on, 24 hours"
if we so decide.

