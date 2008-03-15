Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYCOUXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYCOUXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 16:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYCOUXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 16:23:11 -0400
Received: from phunq.net ([64.81.85.152]:58595 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752710AbYCOUXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 16:23:10 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sat, 15 Mar 2008 12:22:47 -0800
User-Agent: KMail/1.9.5
Cc: David Newall <davidn@davidnewall.com>, Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803122350.56811.phillips@phunq.net> <20080315133242.GB4828@ucw.cz>
In-Reply-To: <20080315133242.GB4828@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803151322.48688.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2008 06:32, Pavel Machek wrote:
> On Wed 2008-03-12 22:50:55, Daniel Phillips wrote:
> > On Wednesday 12 March 2008 23:30, David Newall wrote:
> > > Daniel Phillips wrote:
> > > >> Your idea seems predicated on throwing large amounts of RAM at the
> > > >> problem.  What I want to know is this: Is it really 25 times faster than
> > > >> ext3 with an equally huge buffer cache?
> > > >
> > > > Yes.
> > > 
> > > Well, that sounds convincing.  Not.  You know this how?
> > 
> > By measuring it.  time untar -xf linux-2.2.26.tar; time sync
> 
> Thats cheating. Your ramback ignores sync.
> 
> Just time it against ext3 _without_ doing the sync. That's still more
> reliable than what you have.

No, that allows ext3 to cheat, because ext3 does not supply any means
of flushing its cached data to disk in response to loss of line power,
and then continuing on in a "safe" mode until line power comes back.

Fix that and you will have a replacement for ramback, arguably a more
efficient one for this specialized application (it will not work for an
external ramdisk).  Until you do that, ramback is the only game in town
to get these transaction speeds together with data durability.

I have mentioned a number of times, that you _already_ rely on an
equivalent scheme to ramback if you are using a battery-backed raid
controller. Somehow, posters to this thread keep glossing over that
and going back to the sky-is-falling argument.

Daniel
