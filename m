Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbYLERZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbYLERZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 12:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbYLERZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 12:25:34 -0500
Received: from outbound-mail-105.bluehost.com ([69.89.18.5]:60063 "HELO
	outbound-mail-105.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753630AbYLERZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 12:25:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=AWqdA7bIx4TeeZ0RBO4KLmuiRaV50Xjt4OP6mbWcMvq7U4QS7ItjimBbnLv2mtcq0m5JE2PlOT71mibewnsxid9kFpSYhZ8aJkyctgI3e2Mhlv/fWREJNI1coSXwto/m;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Fri, 5 Dec 2008 09:25:30 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Frans Pop <elendil@planet.nl>,
       Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812041845210.3543@nehalem.linux-foundation.org> <alpine.LFD.2.00.0812041917050.3386@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812041917050.3386@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812050925.31177.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 4, 2008 7:25 pm Linus Torvalds wrote:
> On Thu, 4 Dec 2008, Linus Torvalds wrote:
> > Ok, the ICH6 LPC side has something similar, but not the same. Just two
> > ranges, and slightly less flexible wrt sizing.
> >
> > And ICH8/9/10 seems to have the same thing as ICH7.
>
> Here's a patch that implements what I think is the correct quirks (apart
> from the commented ICH6 lazy detail I didn't do).
>
> It would be very interesting to see if people affected get any printouts
> about IO decodes that don't show up in /proc/ioports...
>
> And I know I've looked for these kinds of things before in the Intel ICH
> docs, and apparently always missed these things (or been too lazy to
> react), so can somebody else see if they can find any other ranges like
> this? Maybe in non-LPC controllers?
>
> Jesse, are there any Intel chipset people who could once and for all say
> "these are the things we decode in our chipset" for _all_ chipsets and
> _all_ dynamic ranges? I've asked for that before. There must be people who
> know this, without having to wade through many thousands of pages of
> boring datasheets?

Yeah, I can get that info.  Sorry I haven't spent more time on this bug so 
far, I've been on vacation this week and very selective about which mails I 
reply to. :)

> The ICH datasheets tend to be 850 pages each, and there is more than one
> of them. And they _do_ differ in the details, even if there is a lot of
> sharing going on. So reading the docs is a huge effort, when there's bound
> to be somebody who just knows the answer.
>
> NOTE! This patch will just add a _printout_ of the IO regions it finds. It
> won't actually register them as known resources. So it won't make the
> kernel know to avoid them if they were to clash!
>
> Also, see the "This is not correct" for the ICH6 dynamically sized case.

Some of these may be listed as ACPI PNP ranges too...

Jesse
