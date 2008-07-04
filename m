Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYGDVRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYGDVRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 17:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYGDVR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 17:17:29 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:55207 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbYGDVR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:17:29 -0400
Message-ID: <486E9366.2090901@skyrush.com>
Date: Fri, 04 Jul 2008 15:17:26 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Elias Oltmanns <eo@nebensachen.de>,
       =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com>	<87fxqurqpz.fsf@denkblock.local>	<486E83C3.1040509@skyrush.com> <20080704212335.4ffc8230@lxorguk.ukuu.org.uk>
In-Reply-To: <20080704212335.4ffc8230@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> disk activity process over each time it completed), it always broke out
>> after one ^C - one time took an extra second or two.  Note that I did
>> not run latencytop (did not have it compiled in my kernel) - if that is
>> required for the test, let me know, but I assume it is just for
>> gathering info when the issue occurs.
> 
> I really don't think this is tty related looking at the code involved and
> also the lack of actual measurements presented. More likely scheduler and
> VM related changes.

Alan, many thanks for your assessment - it's greatly appreciated.  Now
that I've looked into it, the only peculiar thing I see is the redundant
flush_buffer call.  Do you think that should be removed anyway?  It
seems that the following two calls do the same thing in n_tty.c:

		n_tty_flush_buffer(tty);
		tty_driver_flush_buffer(tty);

If this looks redundant, let me know, and I can submit a patch to just
call n_tty_flush_buffer(tty).

					-Thanks, Joe
