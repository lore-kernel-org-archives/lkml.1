Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbYCYCXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbYCYCXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 22:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757245AbYCYCVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 22:21:52 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:41882 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217AbYCYCVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 22:21:51 -0400
Message-ID: <47E86203.5090805@keyaccess.nl>
Date: Tue, 25 Mar 2008 03:22:59 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Michael Cree <mcree@orcon.net.nz>
CC: Bob Tracy <rct@frus.com>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080318032427.298BCDBA2@gherkin.frus.com> <546A47FE-F98E-49E2-A250-41F65C2D482B@orcon.net.nz> <47E6338E.8030001@orcon.net.nz> <47E7EFDF.2070706@keyaccess.nl> <47E83F94.8010409@orcon.net.nz> <47E8475E.4080705@keyaccess.nl> <47E853F2.7020608@orcon.net.nz>
In-Reply-To: <47E853F2.7020608@orcon.net.nz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-03-08 02:22, Michael Cree wrote:

>> should do it. Here's a file Bob passed me as a problematic one. 8-bit, 
>> 11025, mono:
>>
>> http://members.home.nl/rene.herman/asskickd.wav
> 
> Right, got that.  On the PWS600au it shows the same problems that Bob 
> describes!  When I play it with aplay (through the es1887) I get the 
> last "pal" repeated at the end.  When I play it with sox (also through 
> the es1887) I get the words "current event" repeated at the end.
> 
> Playing through the CM8738 also repeats the words "current event" at the 
> end when playing with sox.  But using aplay through the CM8738 only 
> results in silence and aplay hangs.  A ctrl-c successfully breaks it.

Lovely, so different problem between you and Bob. When you (either of you) 
have some time for it again, could you try:

$ sox asskickd.wav -w -t alsa hw
$ sox asskickd.wav -w -r 44100 -t alsa hw
$ sox asskickd.wav -w -r 44100 -c 2 -t alsa hw

and report if things start working? First transforms into 16-bit, second 
16-bit and 44100 rate, third 16-bit, 44100 rate, stereo.

> I suspect you are right - the symptoms I have observed (complete system 
> crashes) are separate from what Bob observes.  One question I have is 
> what is different about Bob's set up that enables the sound to work with 
> mmap?

Not a clue. Takashi -- is it possible that Bob wasn't using mmap to being 
with if he didn't do anything specific to not do so?

And perhaps you guys have firmware settable options that touch that area of 
coherent DMA? Maybe even a specific chipset bug on his machine? No idea how 
different/similar your machines are...

> On the XP1000 (which has an unmodified kernel 2.6.24.3) I managed to 
> play the sound file once with aplay through the es1887 (and it repeated 
> "pal" at the end).  Then I tried using sox and complete silence 
> resulted.   No,  it's just playing back at the wrong rate - everything 
> is sounding slow and extremely flat - the silence is just the artefact 
> of a little bit of silence at the start of the file being played at far 
> too a slow sample rate.  Even other client programs are affected - mocp 
> is playing back music at a horrendously slow sample rate. Yuk. Hopefully 
> a rmmod es1887 might fix that - but I can't test it to I send this 
> message and shut down X.
> 
> Anyway I really must start marking that pile of assignments I told the 
> students that I would have done by tomorrow.  Further testing will have 
> to wait to later this week.

No rush. Thanks for the current amount of testing already.

Rene.
