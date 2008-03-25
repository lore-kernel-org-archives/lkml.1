Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYCYC0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYCYC0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 22:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYCYC0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 22:26:09 -0400
Received: from mx1.orcon.net.nz ([219.88.242.51]:34220 "EHLO mx1.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbYCYC0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 22:26:08 -0400
Message-ID: <47E853F2.7020608@orcon.net.nz>
Date: Tue, 25 Mar 2008 14:22:58 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Bob Tracy <rct@frus.com>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080318032427.298BCDBA2@gherkin.frus.com> <546A47FE-F98E-49E2-A250-41F65C2D482B@orcon.net.nz> <47E6338E.8030001@orcon.net.nz> <47E7EFDF.2070706@keyaccess.nl> <47E83F94.8010409@orcon.net.nz> <47E8475E.4080705@keyaccess.nl>
In-Reply-To: <47E8475E.4080705@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx1.orcon.net.nz on Tue, 25 Mar 2008 14:23:05 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Mar 25 14:23:18 2008
X-DSPAM-Confidence: 0.7699
X-DSPAM-Improbability: 1 in 336 chance of being spam
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:

>> I can't get sox's play to work (reports no mmap support, which is, of 
>> course, quite true).  I don't know how to tell sox to use the equivalent
>> of alsa's hw device.  So I can't do the test on short files that Bob was
>> performing.
> 
> $ sox foo.wav -t alsa hw

Hmmm :-/  So obvious now that you mention it.

> 
> should do it. Here's a file Bob passed me as a problematic one. 8-bit, 
> 11025, mono:
> 
> http://members.home.nl/rene.herman/asskickd.wav

Right, got that.  On the PWS600au it shows the same problems that Bob 
describes!  When I play it with aplay (through the es1887) I get the 
last "pal" repeated at the end.  When I play it with sox (also through 
the es1887) I get the words "current event" repeated at the end.

Playing through the CM8738 also repeats the words "current event" at the 
end when playing with sox.  But using aplay through the CM8738 only 
results in silence and aplay hangs.  A ctrl-c successfully breaks it.

I suspect you are right - the symptoms I have observed (complete system 
crashes) are separate from what Bob observes.  One question I have is 
what is different about Bob's set up that enables the sound to work with 
mmap?

On the XP1000 (which has an unmodified kernel 2.6.24.3) I managed to 
play the sound file once with aplay through the es1887 (and it repeated 
"pal" at the end).  Then I tried using sox and complete silence 
resulted.   No,  it's just playing back at the wrong rate - everything 
is sounding slow and extremely flat - the silence is just the artefact 
of a little bit of silence at the start of the file being played at far 
too a slow sample rate.  Even other client programs are affected - mocp 
is playing back music at a horrendously slow sample rate. Yuk. 
Hopefully a rmmod es1887 might fix that - but I can't test it to I send 
this message and shut down X.

Anyway I really must start marking that pile of assignments I told the 
students that I would have done by tomorrow.  Further testing will have 
to wait to later this week.

Michael.

