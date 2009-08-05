Return-Path: <linux-kernel-owner+w=401wt.eu-S964831AbZHERAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964831AbZHERAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 13:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934703AbZHERAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 13:00:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57115 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934694AbZHERAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 13:00:41 -0400
Date: Wed, 5 Aug 2009 18:01:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <teheo@suse.de>
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
Message-ID: <20090805180120.4c9e612f@lxorguk.ukuu.org.uk>
In-Reply-To: <4A79B8CA.8050504@suse.de>
References: <4A79283E.7030202@kernel.org>
	<4A79296A.4090600@suse.de>
	<20090805101551.6ee053e5@lxorguk.ukuu.org.uk>
	<4A7951B0.10208@suse.de>
	<20090805110031.51424dbe@lxorguk.ukuu.org.uk>
	<4A796C94.5040301@suse.de>
	<20090805134823.4409e197@lxorguk.ukuu.org.uk>
	<4A799392.3000108@suse.de>
	<20090805152942.42e785f3@lxorguk.ukuu.org.uk>
	<4A79AD2A.4060308@suse.de>
	<20090805173346.130d80bb@lxorguk.ukuu.org.uk>
	<4A79B8CA.8050504@suse.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. Merge the weird switch thing and the extra standard chrdev module
>    alias patch

Might as well fake the normal aliases in soundcore if loaded rather than
pollute chardev with it but otherwise I think we agree.


> 2. Add to feature-removal that snd-slot/service-* are going away in a
>    year along with the weird switches.  This allows people who wish to
>    try or switch in the meantime to do so.

Yep

> 3. After a year, drop module loading related code from sound_core
>    along with the weird config option and kernel parameter.

Do we need soundcore at all at that point ? It seems phase 3 is "move any
needed logic to ALSA oss emulation and kill it off"

> In the end, the only choice we have to make is whether to keep
> snd-slot/service-* aliases.  If we're gonna (I don't see why tho), the

I think we need to for a year or so - and its trivial to do so.

> cleanest way would be to teach chrdev about aliases.  If not, the best
> way is to add a switch so that it can be phased out gradually.

In the mean time if you are grabbing just some minors sound_core.c:chains
also needs keeping in sync with direct character range grabs because your
CUSE based device might grab some minors before sound_core, and then it
appears tears will result ?




