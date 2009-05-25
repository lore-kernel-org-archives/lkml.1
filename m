Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbZEYRuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbZEYRuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 13:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZEYRup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 13:50:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:5458 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZEYRuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 13:50:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=SfvGVJrxg+eUEVbC5kOKpPXG9wkj2Nnh+AQCNEcLhc70cidCw5BFh5Nbj4qeX07W6G
         6rydQiWiK3WJjCkwVgMIYjeQSLmUadPFMXFaMnKmNVtK1YK4TMEyPluIhv9wxv8cSn+E
         AD9ZBmsIPRfzoyqBu8TRXxyc2YyvWIfR0NjsU=
MIME-Version: 1.0
In-Reply-To: <f3177b9e0905251023n762b815akace1ae34e643458e@mail.gmail.com>
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
	 <20090524101551.57b706e9@infradead.org>
	 <20090524173933.GD24753@cip.informatik.uni-erlangen.de>
	 <20090525120320.GA25908@mit.edu>
	 <20090525123430.GA5534@cip.informatik.uni-erlangen.de>
	 <87ab51qq91.fsf@frosties.localdomain>
	 <f3177b9e0905251023n762b815akace1ae34e643458e@mail.gmail.com>
Date: Mon, 25 May 2009 11:26:15 -0600
Message-ID: <f3177b9e0905251026u54d6b1e0s884dbdedf74b17cd@mail.gmail.com>
Subject: RE: zero out blocks of freed user data for operation a virtual 
	machine environment
From: Chris Worley <worleys@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 7:14 AM, Goswin von Brederlow <goswin-v-b@web.de> wrote:
> Thomas Glanzmann <thomas@glanzmann.de> writes:
> > Hello Ted,
> >
> >> Yes, it does, sb_issue_discard().  So if you wanted to hook into this
> >> routine with a function which issued calls to zero out blocks, it
> >> would be easy to create a private patch.
> >
> > that sounds good because it wouldn't only target the most used
> > filesystem but every other filesystem that uses the interface as well.
> > Do you think that a tunable or configurable patch has a chance to hit
> > upstream as well?
> >
> >         Thomas
>
> I could imagine a device mapper target that eats TRIM commands and
> writes out zeroes instead. That should be easy to maintain outside or
> inside the upstream kernel source.

Why bother with a time-consuming performance-draining operation?
There are devices that already support TRIM/discard commands today,
and once you discard a block, it's completely irretrievable (you'll
just get back zeros if you try to read that block w/o writing it after
the discard).

Chris
>
>
> MfG
>        Goswin
