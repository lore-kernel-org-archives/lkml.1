Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbYCTVIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbYCTVIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 17:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbYCTVIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 17:08:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:1444 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbYCTVIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 17:08:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y1arEVUhnncOdRWa3MAyda6UC07ouoEJ5rPTuifcZErU9Biy8WxXLfS/iI+5ZAEQ4KU103b2wQw9AI7JOjw34gJ6kL092tP9DZIVmzc1C5huYek7YpuqFGuSn6uFSjx06GKJNFvNDiFI7EoRT2tdc5akkyTPqi2G6iqNP6iqSe4=
Message-ID: <5a4c581d0803201401w6a6d60banf9d306f361f791d9@mail.gmail.com>
Date: Thu, 20 Mar 2008 22:01:13 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Rene Herman" <rene.herman@keyaccess.nl>
Subject: Re: ehci-hcd affects hda speed
Cc: "Lev A. Melnikovsky" <melnikovsky@mail.ru>,
       "David Brownell" <david-b@pacbell.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <47E24C0F.1070901@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr>
	 <200803171700.26274.david-b@pacbell.net> <47DF19AD.405@keyaccess.nl>
	 <200803171855.44552.david-b@pacbell.net>
	 <alpine.LFD.1.00.0803200211230.31035@nev.ubzr>
	 <47E1B062.4060709@keyaccess.nl>
	 <5a4c581d0803192208w6db8f2aaj42eac883de126585@mail.gmail.com>
	 <47E24C0F.1070901@keyaccess.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 12:35 PM, Rene Herman <rene.herman@keyaccess.nl> wrote:
> On 20-03-08 06:08, Alessandro Suardi wrote:
>
>  > On Thu, Mar 20, 2008 at 1:31 AM, Rene Herman <rene.herman@keyaccess.nl> wrote:
>
>
> >>  I do wonder -- is your hda throughput also the same before _ever_ attaching
>  >>  anything to the EHCI controller and after? In my case, the slow down only
>  >>  happened after switching on my external USB drive once, and would persist
>  >>  from that time until reboot (or unloading ehci-hcd, which I kept modular for
>  >>  exactly that reason).
>  >>
>  >>  The sleep time wasn't the core problem, so I wonder of later VIA chips do
>  >>  still have the active async schedule problem...
>  >>
>  >>  Alessandro? You said there still was a difference for you between no EHCI at
>  >>  all and EHCI after tweaking 4B as Lev showed. How much?
>  >
>  > When used setpci to tweak the setting, my hdparm -t went
>  >  from 17 to 25MB/s on /dev/hda.
>  >
>  > With your patch applied, now after booting it says 33MB/s for
>  >  hda and 37MB/s on hdb (and I can burn DVDs at a stable 6x
>  >  now, while growisofs backed off to 4x in less than a minute
>  >  before the patch).
>  >
>  > If the patch does exactly what setpci did, then perhaps I had
>  >  other activity on hda at the moment I ran the test...
>
>  Yes, should be the exact same. It could be what I noted -- that you have the
>  33/37 just after booting, and a drop to 25 again after having switched
>  on/used a EHCI device for the first time? That would be interesting.
>
>  Rene.

It just seems to be oscillating. The following is a series of
 consecutive hdparm -t (when one is finished, I hit up-arrow
 and then Enter again):

[root@donkey ~]# hdparm -t /dev/hda

/dev/hda:
 Timing buffered disk reads:   86 MB in  3.01 seconds =  28.57 MB/sec
[root@donkey ~]# hdparm -t /dev/hda

/dev/hda:
 Timing buffered disk reads:   88 MB in  3.00 seconds =  29.30 MB/sec
[root@donkey ~]# hdparm -t /dev/hda

/dev/hda:
 Timing buffered disk reads:   92 MB in  3.04 seconds =  30.31 MB/sec
[root@donkey ~]# hdparm -t /dev/hda

/dev/hda:
 Timing buffered disk reads:   88 MB in  3.05 seconds =  28.86 MB/sec
[root@donkey ~]# hdparm -t /dev/hda

/dev/hda:
 Timing buffered disk reads:   98 MB in  3.03 seconds =  32.38 MB/sec


hdb is definitely more stable...

[root@donkey ~]# hdparm -t /dev/hdb

/dev/hdb:
 Timing buffered disk reads:  108 MB in  3.02 seconds =  35.79 MB/sec
[root@donkey ~]# hdparm -t /dev/hdb

/dev/hdb:
 Timing buffered disk reads:  110 MB in  3.03 seconds =  36.36 MB/sec
[root@donkey ~]# hdparm -t /dev/hdb

/dev/hdb:
 Timing buffered disk reads:  110 MB in  3.04 seconds =  36.24 MB/sec
[root@donkey ~]# hdparm -t /dev/hdb

/dev/hdb:
 Timing buffered disk reads:  110 MB in  3.04 seconds =  36.24 MB/sec


Though I only have light activity on /dev/hda - four torrents
 uploading at a cumulative 33KB/s via bittorrent-4.4.0-2
 (and no activity on /dev/hdb).

/dev/sda, the USB external storage, is mounted but currently
 not really accessed. However, the slowdown for me did
 appear even modprob'ing ehci_hcd - without even mounting
 /dev/sda.

Oh, now that you make me look... /dev/sda hdparm -t dropped
 from 22MB/s to ~16MB/s - see my email of a while ago

http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-10/msg09679.html

 versus the current

[root@donkey ~]# hdparm -t /dev/sda

/dev/sda:
 Timing buffered disk reads:   48 MB in  3.02 seconds =  15.90 MB/sec
[root@donkey ~]# hdparm -t /dev/sda

/dev/sda:
 Timing buffered disk reads:   48 MB in  3.02 seconds =  15.90 MB/sec

--alessandro

 "We act as though comfort and luxury were the chief requirements
 of life, when all that we need to make us really happy is
 something to be enthusiastic about."

 (Charles Kingsley)
