Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZHFFz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZHFFz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 01:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZHFFz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 01:55:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbZHFFz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 01:55:57 -0400
Message-ID: <4A7A7067.4060701@suse.de>
Date: Thu, 06 Aug 2009 14:55:51 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
References: <4A79283E.7030202@kernel.org>	<4A79296A.4090600@suse.de>	<20090805101551.6ee053e5@lxorguk.ukuu.org.uk>	<4A7951B0.10208@suse.de>	<20090805110031.51424dbe@lxorguk.ukuu.org.uk>	<4A796C94.5040301@suse.de>	<20090805134823.4409e197@lxorguk.ukuu.org.uk>	<4A799392.3000108@suse.de>	<20090805152942.42e785f3@lxorguk.ukuu.org.uk>	<4A79AD2A.4060308@suse.de>	<20090805173346.130d80bb@lxorguk.ukuu.org.uk>	<4A79B8CA.8050504@suse.de> <20090805180120.4c9e612f@lxorguk.ukuu.org.uk>
In-Reply-To: <20090805180120.4c9e612f@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

Alan Cox wrote:
>> 1. Merge the weird switch thing and the extra standard chrdev module
>>    alias patch
> 
> Might as well fake the normal aliases in soundcore if loaded rather than
> pollute chardev with it but otherwise I think we agree.

Yeap, that was what I meant by the second part of the sentence.

>> 2. Add to feature-removal that snd-slot/service-* are going away in a
>>    year along with the weird switches.  This allows people who wish to
>>    try or switch in the meantime to do so.
> 
> Yep
> 
>> 3. After a year, drop module loading related code from sound_core
>>    along with the weird config option and kernel parameter.
> 
> Do we need soundcore at all at that point ? It seems phase 3 is "move any
> needed logic to ALSA oss emulation and kill it off"

Yeah, sure.  There's nothing preventing ALSA from directly registering
chrdevs.

>> In the end, the only choice we have to make is whether to keep
>> snd-slot/service-* aliases.  If we're gonna (I don't see why tho), the
> 
> I think we need to for a year or so - and its trivial to do so.
> 
>> cleanest way would be to teach chrdev about aliases.  If not, the best
>> way is to add a switch so that it can be phased out gradually.
> 
> In the mean time if you are grabbing just some minors sound_core.c:chains
> also needs keeping in sync with direct character range grabs because your
> CUSE based device might grab some minors before sound_core, and then it
> appears tears will result ?

Hmmm... okay, will take a deeper look at that.

Thanks.

-- 
tejun
