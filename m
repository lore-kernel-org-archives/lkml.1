Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555AbYCQQPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbYCQQPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 12:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYCQQPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 12:15:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:39816 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbYCQQPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 12:15:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AdaAdf+cpwW+qZGvaO81uaOnDy/Wf5te+QgCs5b0RKjKAHYw/fqyD18Sek8StDny8nJBySc/osLg+v3DQd/TVA9QmmfVEpiMgrrv5c/ijaheGHqsMLwS+eqQf6sunh2h4YD/qrVLqKLWf1s6L2v39Zxm6dIaJN6pZNhX08bbwHo=
Message-ID: <5a4c581d0803170915r73a9c6e5nbba264936af583ff@mail.gmail.com>
Date: Mon, 17 Mar 2008 17:15:33 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
Subject: Re: ehci-hcd affects hda speed
Cc: "David Brownell" <david-b@pacbell.net>,
       "Rene Herman" <rene.herman@keyaccess.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.00.0803160054360.23451@nev.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr>
	 <47CEC816.6000808@keyaccess.nl>
	 <5a4c581d0803051203s1a0048c2u5f10b3eb442cfafb@mail.gmail.com>
	 <200803051303.46275.david-b@pacbell.net>
	 <alpine.LFD.1.00.0803062244010.10693@nev.ubzr>
	 <alpine.LFD.1.00.0803101303240.4772@nev.ubzr>
	 <alpine.LFD.1.00.0803160054360.23451@nev.ubzr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2008 at 11:46 PM, Lev A. Melnikovsky
<melnikovsky@mail.ru> wrote:
>
>  LAM> Also, does anyone have a VT6212L datasheet? Unfortunately, Google
>  I have eventually found it. An enlightening reading, really. If I
>  understood all words, I mean :-). Particularly, what does "MAC turn around
>  time" stand for with respect to EHCI? I would appreciate some reference,
>  thanks.
>
>   On Wed, 5 Mar 2008 at 5:19pm, Rene Herman wrote:
>
>  RH> It was diagnosed to the VT6212L doing decidedly weird things with
>  RH> toggling the Async bit and tying up the bus.
>  Yes, it really looks like the chip owns the bus when it shouldn't. Suppose
>  VT6212L has damaged its brains somehow. Can we fix this by ignoring its
>  requests unless they are legitimate? I mean make the driver enable bus
>  mastering only for short periods when the controller is expected to do
>  something useful. It is easy (I have already done myself) to implement for
>  asynchronous schedule, but there's still periodic schedule. Is it
>  possible? How? Please advise.
>
>  Being positive, I didn't have much time to play with it yet, but changing
>  the bit 5 (EHCI sleep time select:  0=1us 1=10us) of register 0x4B seems
>  to resolve my own problem. I wonder if this is going to help others
>  (Alessandro?):
>
>  setpci -s 00:09.2 4b.b=29
>
>  [don't forget to adjust the device address].

00:09.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 63)

heh, I don't even have to...

[root@donkey ~]# hdparm -t /dev/hda

/dev/hda:
 Timing buffered disk reads:   54 MB in  3.03 seconds =  17.83 MB/sec
[root@donkey ~]# setpci -s 00:09.2 4b.b=29
[root@donkey ~]# hdparm -t /dev/hda

/dev/hda:
 Timing buffered disk reads:   78 MB in  3.06 seconds =  25.53 MB/sec

Well, that does look much better. Not on par with the non-EHCI case,
 but way better ! Thanks a lot !

Of course if you wish me to run anything else, just say so :)

--alessandro

 "We act as though comfort and luxury were the chief requirements
 of life, when all that we need to make us really happy is
 something to be enthusiastic about."

 (Charles Kingsley)
