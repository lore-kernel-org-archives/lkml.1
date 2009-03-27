Return-Path: <linux-kernel-owner+w=401wt.eu-S1760924AbZC0UNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760924AbZC0UNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761747AbZC0ULU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:11:20 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:43122 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761932AbZC0ULS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:11:18 -0400
X-RZG-AUTH: :LWIQcGC8af5qXkYNYt77sURZEFmV4M3TAgvB+Qeh4tE+44JfzNXcZSc7aQIr
X-RZG-CLASS-ID: mo05
Message-ID: <49CD32E1.2020906@ursus.ath.cx>
Date: Fri, 27 Mar 2009 21:11:13 +0100
From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <20090327171955.78662c1e@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0903271058060.3994@localhost.localdomain> <20090327190339.GW6239@mit.edu> <20090327191426.3d478b6b@lxorguk.ukuu.org.uk> <20090327193249.GY6239@mit.edu>
In-Reply-To: <20090327193249.GY6239@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2009-03-27 20:32 Theodore Tso wrote:
> We could potentially make close() imply fbarrier(), but there are
> plenty of times when that might not be such a great idea.  If we do
> that, we're back to requiring synchronous data writes for all files on
> close()
fbarrier() on close() would only mean, that the data shouldn't be
written after the metadata and new metadata shouldn't be written
_before_ old metadata, so you can also delay the committing of the
"dirty" metadata until the real data are written. You don't need
synchronous data writes necessarily.

> The fundamental idea here is not all files need to be forced to disk
> on close.  Not all files need fsync(), or even fbarrier().
An fbarrier() on close() would reflect the thinking of a lot of
developers. You might call them stupid and incompetent, but they surely
are the majority. When closing A before creating B, they don't expect
seeing B without a completed A, even though they might expect that
neither A nor B may be written yet, if the system crashes.
If you have smart developers, you might give them something new, so they
could speed things up with some extra code, e.g. when they create data,
which may be restored by other means, but the default behavior of
automatic fbarrier() on close() would be better.

Andreas
