Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYCXX4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYCXX4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbYCXX4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:56:10 -0400
Received: from mx4.orcon.net.nz ([219.88.242.54]:45368 "EHLO mx4.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085AbYCXX4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:56:08 -0400
Message-ID: <47E83F94.8010409@orcon.net.nz>
Date: Tue, 25 Mar 2008 12:56:04 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Bob Tracy <rct@frus.com>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080318032427.298BCDBA2@gherkin.frus.com> <546A47FE-F98E-49E2-A250-41F65C2D482B@orcon.net.nz> <47E6338E.8030001@orcon.net.nz> <47E7EFDF.2070706@keyaccess.nl>
In-Reply-To: <47E7EFDF.2070706@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx4.orcon.net.nz on Tue, 25 Mar 2008 12:56:06 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Mar 25 12:56:06 2008
X-DSPAM-Confidence: 0.6203
X-DSPAM-Improbability: 1 in 164 chance of being spam
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 23-03-08 11:40, Michael Cree wrote:
> 
>> I have been able to run some tests.
>>
>> The es18xx and cmipci drivers work fine on the XP1000.  I base that 
>> observation on using a variety of software, such as mplayer and mocp, 
>> through both sound cards, mainly through oss, but also have tried 
>> alsa, over the last year for es18xx and for the last three or four 
>> months for cmipci.  (I have noted that the M-Audio Revolution 7.1 
>> sound card with the ice1724 driver fails to work and causes system 
>> crashes on the XP1000,
>> but that's a different discussion).
> 
> Was there ever a follow-up in that thread? :
> 
> http://mailman.alsa-project.org/pipermail/alsa-devel/2008-March/006513.html

Takashi replied with a suggestion to disable MMAP in the ice1724 driver. 
  I have been preoccupied with other things for the last couple of weeks 
so haven't had a chance to try it out.

> There's a patch attached that disables mmap on MIATA. You and Bob seem 
> to be experiencing problems of a different nature (or severity at the 
> least) but for both of you it would be good to hear what applying this 
> and then playing using "aplay -D hw foo.wav" (on the miata systems, 
> ofcourse) brings.

I have applied the patch to the PWS600au.  Sound now works.  I can play 
8bit and 16bit sound files through the es1887 and the C-Media CM8738. 
They are both working fine.  I managed to get a 32bit sound file to play 
through the M-Audio Revolution too. (Though another 32bit sound file 
just produces silence through the M-Audio Rev. Haven't been able to 
establish why - the file looks fine to me.)  Repeated playing of files 
doesn't cause any problems.

I can't get sox's play to work (reports no mmap support, which is, of 
course, quite true).  I don't know how to tell sox to use the equivalent 
of alsa's hw device.  So I can't do the test on short files that Bob was 
  performing.

At this stage I've run out of time to test the M-Audio Rev in the XP1000 
and see if the MMAP disable patch help there.

Michael.
