Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbZEZKWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbZEZKWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 06:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZEZKWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 06:22:45 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:53835 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZEZKWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 06:22:44 -0400
From: Goswin von Brederlow <goswin-v-b@web.de>
To: Chris Worley <worleys@gmail.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
       LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: zero out blocks of freed user data for operation a virtual  machine environment
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
	<20090524101551.57b706e9@infradead.org>
	<20090524173933.GD24753@cip.informatik.uni-erlangen.de>
	<20090525120320.GA25908@mit.edu>
	<20090525123430.GA5534@cip.informatik.uni-erlangen.de>
	<87ab51qq91.fsf@frosties.localdomain>
	<f3177b9e0905251023n762b815akace1ae34e643458e@mail.gmail.com>
Date: Tue, 26 May 2009 12:22:38 +0200
In-Reply-To: <f3177b9e0905251023n762b815akace1ae34e643458e@mail.gmail.com>
	(Chris Worley's message of "Mon, 25 May 2009 11:23:05 -0600")
Message-ID: <87ab50p3ip.fsf@frosties.localdomain>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.22 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/ymS8SlTjiJbej3dID3uh+EN48BYcinoG+D0ao
	XjU29E43UjS3SvB+MyxakMhhOqy6KLPmZ1NBCQbIgQXw+swGJr
	bFSMyIS1c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Worley <worleys@gmail.com> writes:

> On Mon, May 25, 2009 at 7:14 AM, Goswin von Brederlow <goswin-v-b@web.de>
> wrote:
>
>
>                Thomas Glanzmann <thomas@glanzmann.de> writes:
>      
>      > Hello Ted,
>      >
>      >> Yes, it does, sb_issue_discard().  So if you wanted to hook into
>      this
>      >> routine with a function which issued calls to zero out blocks, it
>      >> would be easy to create a private patch.
>      >
>      > that sounds good because it wouldn't only target the most used
>      > filesystem but every other filesystem that uses the interface as
>      well.
>      > Do you think that a tunable or configurable patch has a chance to
>      hit
>      > upstream as well?
>      >
>      >         Thomas
>      
>      
>
>
>      I could imagine a device mapper target that eats TRIM commands and
>      writes out zeroes instead. That should be easy to maintain outside
>      or
>      inside the upstream kernel source.
>
>
> Why bother with a time-consuming performance-draining operation?  There are
> devices that already support TRIM/discard commands today, and once you discard
> a block, it's completely irretrievable (you'll just get back zeros if you try
> to read that block w/o writing it after the discard).
> Chris 

Because you have one of the billions of devices that don't.

Because, iirc, the specs say nothing about getting back zeros.

Because someone could read the raw data from disk and recover your
state secrets.

Because loopback don't support TRIM and compression of the image file
is much better with zeroes.

Because on a crypted device TRIM would show how much of the device is
in used while zeroing out (before crypting) would result in random
data.

Because it is fun?

So many reasons.

MfG
        Goswin
