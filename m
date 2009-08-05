Return-Path: <linux-kernel-owner+w=401wt.eu-S934686AbZHEQuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934686AbZHEQuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934517AbZHEQuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:50:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:45687 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934451AbZHEQuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:50:08 -0400
Message-ID: <4A79B8CA.8050504@suse.de>
Date: Thu, 06 Aug 2009 01:52:26 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
References: <4A79283E.7030202@kernel.org>	<4A79296A.4090600@suse.de>	<20090805101551.6ee053e5@lxorguk.ukuu.org.uk>	<4A7951B0.10208@suse.de>	<20090805110031.51424dbe@lxorguk.ukuu.org.uk>	<4A796C94.5040301@suse.de>	<20090805134823.4409e197@lxorguk.ukuu.org.uk>	<4A799392.3000108@suse.de>	<20090805152942.42e785f3@lxorguk.ukuu.org.uk>	<4A79AD2A.4060308@suse.de> <20090805173346.130d80bb@lxorguk.ukuu.org.uk>
In-Reply-To: <20090805173346.130d80bb@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I don't see how I would be able to achieve the latter with one liner.
>> Can you please elaborate a little bit?
> 
> It depends how much of a hurry you are in, but for the mainstream we can
> do this
> 
> 1.	Make soundcore also issue the request_module() as if the char
> minor was unclaimed. Mark the old one as obsolete
> 
> 2.	Wait a year while people adjust their scripts to trigger on the
> char event instead (and fix the ordering bits for ALSA if the soundcore
> docs are still valid on that)
> 
> 3.	Apply a patch which makes ALSA use char dev allocation directly
> for its OSS devices and dumps out soundcore, remove soundcore and switch
> any other code using it.

It's quite difficult to think that those now mostly unused module
alises are worth full year of waiting and careful coordination.  I
think we're chasing a non-issue here.  If it really matters, I'll try
to teach chrdev about alternative module alises.

If you think the above is a good solution, how about the following?

1. Merge the weird switch thing and the extra standard chrdev module
   alias patch

2. Add to feature-removal that snd-slot/service-* are going away in a
   year along with the weird switches.  This allows people who wish to
   try or switch in the meantime to do so.

3. After a year, drop module loading related code from sound_core
   along with the weird config option and kernel parameter.

In the end, the only choice we have to make is whether to keep
snd-slot/service-* aliases.  If we're gonna (I don't see why tho), the
cleanest way would be to teach chrdev about aliases.  If not, the best
way is to add a switch so that it can be phased out gradually.

Thanks.

-- 
tejun
