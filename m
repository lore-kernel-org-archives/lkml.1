Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZLYPcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZLYPcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 10:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270AbZLYPcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 10:32:04 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:51697 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbZLYPcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 10:32:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HaPxRNe6zIxtgOS78H+23Xk82OWz1+hwQShBO+GKiC+/OzTocVxZYg3QVS8UOBjNKT
         CwJRt2ar0XqfwfGcSxCs8MvMqz6bTW6fQbHPLLR51MeNZHXeyeKTKw51mPSUP+EXHt9a
         nSqip0telE2IwymtZtIzghVB5M6sIETdynTvQ=
MIME-Version: 1.0
In-Reply-To: <20091225162528.5dbbbea0@mosly>
References: <alpine.LFD.2.00.0912250124410.11466@x200s>
	 <20091225122107.357d7102@mosly> <s5h637vmhcu.wl%tiwai@suse.de>
	 <20091225162528.5dbbbea0@mosly>
Date: Fri, 25 Dec 2009 16:31:58 +0100
Message-ID: <8db1092f0912250731u46637a55lccb77e6cdb376a57@mail.gmail.com>
Subject: Re: intel hda regression: 2.6.33-rc{1,2}: hd-audio0 eats 25% CPU 
	(according to top)
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       =?UTF-8?Q?=C3=89ric_Piel?= <eric.piel@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/25 Sergei Trofimovich <slyich@gmail.com>:

> Done:
>
> d56757abc11a21996d9839c0d4e3b2c3666cd318 is the first bad commit
> commit d56757abc11a21996d9839c0d4e3b2c3666cd318
> Author: Takashi Iwai <tiwai@suse.de>
> Date:   Wed Nov 18 08:00:14 2009 +0100
>
>    ALSA: hda - Replace the rest of jack-detections with snd_hda_jack_detect()
>
>    Signed-off-by: Takashi Iwai <tiwai@suse.de>
>
> :040000 040000 46040881f7bc4b662a784ac66a6482c2a5b3dca5 6a76aa47a3d0cccad0c8a3ae62cb63ecbdd9b44d M      sound
>
> Bisect log:
> git bisect start '--' 'sound/pci/hda'
> # bad: [55639353a0035052d9ea6cfe4dde0ac7fcbb2c9f] Linux 2.6.33-rc1
> git bisect bad 55639353a0035052d9ea6cfe4dde0ac7fcbb2c9f
> # good: [22763c5cf3690a681551162c15d34d935308c8d7] Linux 2.6.32
> git bisect good 22763c5cf3690a681551162c15d34d935308c8d7
> # good: [123c07aeddd71fbb295842a8c19866e780b9a100] ALSA: hda_intel: Digital PC Beep - change behaviour for input layer
> git bisect good 123c07aeddd71fbb295842a8c19866e780b9a100
> # good: [123c07aeddd71fbb295842a8c19866e780b9a100] ALSA: hda_intel: Digital PC Beep - change behaviour for input layer
> git bisect good 123c07aeddd71fbb295842a8c19866e780b9a100
> # bad: [0b587fc4d35afb1bc0fc3d890084bb14c78372dc] ALSA: hda: Fix max PCM level to 0 dB for Fujitsu-Siemens laptops using CX2054
> 9 (Venice)
> git bisect bad 0b587fc4d35afb1bc0fc3d890084bb14c78372dc
> # good: [23ccc2bd246a5bdb1ac03dc9040a0585c1890ef3] ALSA: intelhdmi - export monitor-presence and ELD-valid status
> git bisect good 23ccc2bd246a5bdb1ac03dc9040a0585c1890ef3
> # bad: [d56757abc11a21996d9839c0d4e3b2c3666cd318] ALSA: hda - Replace the rest of jack-detections with snd_hda_jack_detect()
> git bisect bad d56757abc11a21996d9839c0d4e3b2c3666cd318
> # good: [848de598eef9603d6f2c174f90fded4e63ac5e23] ALSA: intelhdmi - sticky infoframe
> git bisect good 848de598eef9603d6f2c174f90fded4e63ac5e23
> # good: [81bf31e2d0a6a9f5d83da0a757f8ca03db908162] ALSA: intelhdmi - sticky channel count
> git bisect good 81bf31e2d0a6a9f5d83da0a757f8ca03db908162
> # good: [83d605fd63e704419ccb92d48b735c6890ce3d6a] ALSA: hda - show EPSS capability in proc
> git bisect good 83d605fd63e704419ccb92d48b735c6890ce3d6a
>
> Sorry, was unable to revert that commit on top of current 2.6.33-rc2 and verify it's guilty.
>
>> Takashi
>
> --
>
>  Sergei
>

Good work. I already find some time to test, and I have the same
bisection's result, so I think that this commit cause problem.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
