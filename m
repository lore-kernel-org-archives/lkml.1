Return-Path: <linux-kernel-owner+w=401wt.eu-S1759071AbZEEWeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071AbZEEWeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 18:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbZEEWeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 18:34:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51104 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752100AbZEEWeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 18:34:03 -0400
Date: Tue, 5 May 2009 23:33:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akataria@vmware.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
Message-ID: <20090505233339.542880f8@lxorguk.ukuu.org.uk>
In-Reply-To: <1241561394.8665.31.camel@alok-dev1>
References: <1241462661.412.8.camel@alok-dev1>
	<4A00ADDE.9000908@zytor.com>
	<20090505224417.0f00c2f0@lxorguk.ukuu.org.uk>
	<1241561394.8665.31.camel@alok-dev1>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IMO, one of the main motives of HRT implementation apart from getting
> higher precision timers was that we now don't necessarily need to rely

Timer frequency and HZ are two entirely different things nowdyas

> on a high timer frequency. If you see problems with Desktop feel and
> responsiveness don't you think there would be other problem which might
> be causing that ?  Your argument about the "desktop feel and
> responsiveness" doesn't explain what actual problem did you see.

People spent months poking at the differences before HZ=1000 became the
default. It wasn't due for amusement values - but this is irrelevant
anyway on a modern kernel as HZ=1000 is simply a precision setting that
affects things like poll()

HZ on a tickless system has no meaningful relationship to wakup rates -
which are what I assume you actually care about.

So do you want to change the precision of poll() and other
functionality ? or do you want to change the wakeup rates and
corresponding virtualisation overhead ?

If the latter then HZ is not the thing to touch.

What are you *actually* trying to achieve ?
What measurements have you done that make you think HZ is relevant in a
tickless kernel ?


Alan
