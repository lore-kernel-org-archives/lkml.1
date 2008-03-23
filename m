Return-Path: <linux-kernel-owner+w=401wt.eu-S1761869AbYCWNZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761869AbYCWNZm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 09:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756905AbYCWNZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 09:25:32 -0400
Received: from mail-07.jhb.wbs.co.za ([196.2.97.4]:36862 "EHLO
	mail-07.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325AbYCWNZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 09:25:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQIAJP25UfEAmHEZGdsb2JhbACRCxwplRE
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] bttv: Add a radio compat_ioctl file operation.
Date: Sun, 23 Mar 2008 15:25:22 +0200
User-Agent: KMail/1.9.9
Cc: Robert Fitzsimons <robfitz@273k.net>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
References: <200802171036.19619.bonganilinux@mweb.co.za> <200803222017.40862.bonganilinux@mweb.co.za> <Pine.LNX.4.64.0803222027350.6294@bombadil.infradead.org>
In-Reply-To: <Pine.LNX.4.64.0803222027350.6294@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803231525.22278.bonganilinux@mweb.co.za>
X-Original-Subject: Re: [PATCH] bttv: Add a radio compat_ioctl file operation.
X-Scan-Signature: 1be5fcfa35d71816e74c59450cb7b5a6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 March 2008 03:01:42 Mauro Carvalho Chehab wrote:
> On Sat, 22 Mar 2008, Bongani Hlope wrote:
> > On Saturday 22 March 2008 02:05:57 Robert Fitzsimons wrote:
> >> Signed-off-by: Robert Fitzsimons <robfitz@273k.net>
> >> ---
> >>  drivers/media/video/bt8xx/bttv-driver.c |    1 +
> >>  1 files changed, 1 insertions(+), 0 deletions(-)
> >>
> >>
> >> Hi Bongani
> >>
> >> I only noticed that you might be using a 32 bit userspace, so the radio
> >> compat_ioctl needs to be implmented.
> >>
> >> Robert
> >>
> >>
> >>
> >> diff --git a/drivers/media/video/bt8xx/bttv-driver.c
> >> b/drivers/media/video/bt8xx/bttv-driver.c index 5404fcc..1bdb726 100644
> >> --- a/drivers/media/video/bt8xx/bttv-driver.c
> >> +++ b/drivers/media/video/bt8xx/bttv-driver.c
> >> @@ -3601,6 +3601,7 @@ static const struct file_operations radio_fops =
> >>  	.read     = radio_read,
> >>  	.release  = radio_release,
> >>  	.ioctl	  = video_ioctl2,
> >> +	.compat_ioctl	= v4l_compat_ioctl32,
> >>  	.llseek	  = no_llseek,
> >>  	.poll     = radio_poll,
> >>  };
> >
> > I run a 64-bit kernel and 64-bit user-space, only a chrooted version of
> > mplayer and it's dependencies are 32 bit, and I don't use them that
> > often.
> >
> > file /usr/bin/radio
> > /usr/bin/radio: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), for
> > GNU/Linux 2.6.9, dynamically linked (uses shared libs), stripped
> >
> > That patch doesn't help also...
>
> Unfortunately, I coudn't reproduce your bug here.
>
> I tested with a bttv board, plus two radio applications - radio and kradio
> (radio-3.95-7mdv2008.0 and kradio-1.0-0.r497.3mdv2008.0 packages). None of
> them used V4L1 API. I also tested reading frequency, using
>  	v4l-info /dev/radio0
>

rpm -qa | grep radio
radio-3.95-7mdv2008.0

strace of radio
...
munmap(0x7f9796ebc000, 168278)          = 0
open("/dev/radio", O_RDONLY)            = 3
ioctl(3, SONYPI_IOCGBAT2CAP or VIDIOCGTUNER <unfinished ...>
                                                                       ^^^^
								v4l1 API
+++ killed by SIGKILL +++
Process 5164 detached


> I also used ioctl-test, running all V4L1 API calls, with this result
> (I've enabled debug on v4l1-compat, and added a small patch to bttv to use
> video_ioctl2 debug):
>
> Linux video capture interface: v2.00
> bttv: driver version 0.9.17 loaded
> bttv: using 8 buffers with 2080k (520 pages) each for capture
> bttv: Bt8xx card found (0).
> bttv0: Bt848 (rev 17) at 0000:05:06.0, irq: 16, latency: 32, mmio:
> 0xce000000 bttv0: using: STB, Gateway P/N 6000699 (bt848) [card=3,insmod
> option] bttv0: gpio: en=00000000, out=00000000 in=00fbffff [init]
> bttv0: tuner type=2
> bttv0: i2c: checking for TDA9875 @ 0xb0... not found
> bttv0: i2c: checking for TDA7432 @ 0x8a... not found
> bttv0: registered device video0
> bttv0: registered device vbi0
> bttv0: registered device radio0
> BT848 radio (STB, Gateway P/N 6: err:
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_STREAMOFF, dir=-w
> (0x40045613) BT848 radio (STB, Gateway P/N 6: err:
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_OVERLAY, dir=-w
> (0x4004560e) v4l1-compat: VIDIOCCAPTURE / VIDIOC_PREVIEW: -22
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_AUDIO, dir=r-
> (0x80345621) BT848 radio (STB, Gateway P/N 6: Get for index=0
> BT848 radio (STB, Gateway P/N 6: index=0, name=Radio, capability=0, mode=0
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw
> (0xc0445624) BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42,
> min/max=0/0, step=0, default=0, flags=0x00000001 BT848 radio (STB, Gateway
> P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624) BT848 radio (STB,
> Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0,
> flags=0x00000001 BT848 radio (STB, Gateway P/N 6: v4l2 ioctl
> VIDIOC_QUERYCTRL, dir=rw (0xc0445624) BT848 radio (STB, Gateway P/N 6:
> id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw
> (0xc0445624) BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42,
> min/max=0/0, step=0, default=0, flags=0x00000001 BT848 radio (STB, Gateway
> P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624) BT848 radio (STB,
> Gateway P/N 6: id=9963785, type=2, name=Mute, min/max=0/1, step=0,
> default=0, flags=0x00000000 BT848 radio (STB, Gateway P/N 6: v4l2 ioctl
> VIDIOC_G_CTRL, dir=rw (0xc008561b) BT848 radio (STB, Gateway P/N 6: Enum
> for index=9963785
> BT848 radio (STB, Gateway P/N 6: id=9963785, value=-32512
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw
> (0xc0445624) BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42,
> min/max=0/0, step=0, default=0, flags=0x00000001 BT848 radio (STB, Gateway
> P/N 6: v4l2 ioctl VIDIOC_G_TUNER, dir=rw (0xc054561d) BT848 radio (STB,
> Gateway P/N 6: index=0, name=Radio, type=1, capability=0, rangelow=0,
> rangehigh=0, signal=0, afc=0, rxsubchans=0, audmode=0 BT848 radio (STB,
> Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCAP, dir=r- (0x80685600) BT848 radio
> (STB, Gateway P/N 6: driver=bttv, card=BT848 radio (STB, Gateway P/N 6,
> bus=PCI:0000:05:06.0, version=0x00000911, capabilities=0x00010000 BT848
> radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_ENUMINPUT, dir=rw (0xc050561a)
> BT848 radio (STB, Gateway P/N 6: index=0, name=Radio, type=1, audioset=0,
> tuner=0, std=00000000, status=0 BT848 radio (STB, Gateway P/N 6: err:
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_ENUMINPUT, dir=rw
> (0xc050561a) BT848 radio (STB, Gateway P/N 6: err:
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_ENUM_FMT, dir=rw
> (0xc0405602) BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_ENUMINPUT,
> dir=rw (0xc050561a) BT848 radio (STB, Gateway P/N 6: index=0, name=Radio,
> type=1, audioset=0, tuner=0, std=00000000, status=0 BT848 radio (STB,
> Gateway P/N 6: v4l2 ioctl VIDIOC_G_STD, dir=r- (0x80085617) BT848 radio
> (STB, Gateway P/N 6: value=00000000
> BT848 radio (STB, Gateway P/N 6: err:
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FBUF, dir=r-
> (0x8030560a) v4l1-compat: VIDIOCGFBUF / VIDIOC_G_FBUF: -22
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FREQUENCY, dir=rw
> (0xc02c5638) BT848 radio (STB, Gateway P/N 6: tuner=0, type=1, frequency=0
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw
> (0xc0445624) BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42,
> min/max=0/0, step=0, default=0, flags=0x00000001 BT848 radio (STB, Gateway
> P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624) BT848 radio (STB,
> Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0,
> flags=0x00000001 BT848 radio (STB, Gateway P/N 6: v4l2 ioctl
> VIDIOC_QUERYCTRL, dir=rw (0xc0445624) BT848 radio (STB, Gateway P/N 6:
> id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw
> (0xc0445624) BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42,
> min/max=0/0, step=0, default=0, flags=0x00000001 BT848 radio (STB, Gateway
> P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624) BT848 radio (STB,
> Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0,
> flags=0x00000001 BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT,
> dir=rw (0xc0d05604) BT848 radio (STB, Gateway P/N 6: type=video-cap
> BT848 radio (STB, Gateway P/N 6: err:
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw
> (0xc0d05604) v4l1-compat: VIDIOCGPICT / VIDIOC_G_FMT: -22
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_TUNER, dir=rw
> (0xc054561d) BT848 radio (STB, Gateway P/N 6: index=0, name=Radio, type=1,
> capability=0, rangelow=0, rangehigh=0, signal=0, afc=0, rxsubchans=0,
> audmode=0 BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_STD, dir=r-
> (0x80085617) BT848 radio (STB, Gateway P/N 6: value=00000000
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw
> (0xc0d05604) BT848 radio (STB, Gateway P/N 6: type=vbi-cap
> BT848 radio (STB, Gateway P/N 6: err:
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw
> (0xc0d05604) v4l1-compat: VIDIOCGVBIFMT / VIDIOC_G_FMT: -22
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw
> (0xc0d05604) BT848 radio (STB, Gateway P/N 6: type=video-over
> BT848 radio (STB, Gateway P/N 6: err:
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw
> (0xc0d05604) v4l1-compat: VIDIOCGWIN / VIDIOC_G_WIN: -22
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw
> (0xc0d05604) BT848 radio (STB, Gateway P/N 6: type=video-cap
> BT848 radio (STB, Gateway P/N 6: err:
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw
> (0xc0d05604) v4l1-compat: VIDIOCGWIN / VIDIOC_G_FMT: -22
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw
> (0xc0d05604) BT848 radio (STB, Gateway P/N 6: type=video-cap
> BT848 radio (STB, Gateway P/N 6: err:
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw
> (0xc0d05604) v4l1-compat: VIDIOCMCAPTURE / VIDIOC_G_FMT: -22
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_S_AUDIO, dir=-w
> (0x40345622) BT848 radio (STB, Gateway P/N 6: index=0, name=, capability=0,
> mode=0 BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw
> (0xc0445624) BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42,
> min/max=0/0, step=0, default=0, flags=0x00000001 BT848 radio (STB, Gateway
> P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624) BT848 radio (STB,
> Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0,
> flags=0x00000001 BT848 radio (STB, Gateway P/N 6: v4l2 ioctl
> VIDIOC_QUERYCTRL, dir=rw (0xc0445624) BT848 radio (STB, Gateway P/N 6:
> id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw
> (0xc0445624) BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42,
> min/max=0/0, step=0, default=0, flags=0x00000001 BT848 radio (STB, Gateway
> P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624) BT848 radio (STB,
> Gateway P/N 6: id=9963785, type=2, name=Mute, min/max=0/1, step=0,
> default=0, flags=0x00000000 BT848 radio (STB, Gateway P/N 6: v4l2 ioctl
> VIDIOC_S_CTRL, dir=rw (0xc008561c) BT848 radio (STB, Gateway P/N 6:
> id=9963785, value=0
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_TUNER, dir=rw
> (0xc054561d) BT848 radio (STB, Gateway P/N 6: index=0, name=Radio, type=1,
> capability=0, rangelow=0, rangehigh=0, signal=0, afc=0, rxsubchans=0,
> audmode=0 BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_S_TUNER,
> dir=-w (0x4054561e) BT848 radio (STB, Gateway P/N 6: index=0, name=Radio,
> type=1, capability=0, rangelow=0, rangehigh=0, signal=0, afc=0,
> rxsubchans=0, audmode=0 BT848 radio (STB, Gateway P/N 6: v4l2 ioctl
> VIDIOC_S_INPUT, dir=rw (0xc0045627) BT848 radio (STB, Gateway P/N 6:
> value=0
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_S_STD, dir=-w
> (0x40085618) BT848 radio (STB, Gateway P/N 6: value=000000ff
> BT848 radio (STB, Gateway P/N 6: err:
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_S_FBUF, dir=-w
> (0x4030560b) v4l1-compat: VIDIOCSFBUF / VIDIOC_S_FBUF: -22
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FREQUENCY, dir=rw
> (0xc02c5638) BT848 radio (STB, Gateway P/N 6: tuner=0, type=1, frequency=0
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_S_FREQUENCY, dir=-w
> (0x402c5639) BT848 radio (STB, Gateway P/N 6: tuner=0, type=1, frequency=0
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw
> (0xc0445624) BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42,
> min/max=0/0, step=0, default=0, flags=0x00000001 BT848 radio (STB, Gateway
> P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624) BT848 radio (STB,
> Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0,
> flags=0x00000001 BT848 radio (STB, Gateway P/N 6: v4l2 ioctl
> VIDIOC_QUERYCTRL, dir=rw (0xc0445624) BT848 radio (STB, Gateway P/N 6:
> id=0, type=0, name=42, min/max=0/0, step=0, default=0, flags=0x00000001
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw
> (0xc0445624) BT848 radio (STB, Gateway P/N 6: id=0, type=0, name=42,
> min/max=0/0, step=0, default=0, flags=0x00000001 BT848 radio (STB, Gateway
> P/N 6: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624) BT848 radio (STB,
> Gateway P/N 6: id=0, type=0, name=42, min/max=0/0, step=0, default=0,
> flags=0x00000001 BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT,
> dir=rw (0xc0d05604) BT848 radio (STB, Gateway P/N 6: type=video-cap
> BT848 radio (STB, Gateway P/N 6: err:
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw
> (0xc0d05604) v4l1-compat: VIDIOCSPICT / VIDIOC_G_FMT: -22
> BT848 radio (STB, Gateway P/N 6: err:
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FBUF, dir=r-
> (0x8030560a) v4l1-compat: VIDIOCSPICT / VIDIOC_G_FBUF: -22
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_S_INPUT, dir=rw
> (0xc0045627) BT848 radio (STB, Gateway P/N 6: value=0
> BT848 radio (STB, Gateway P/N 6: err:
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_STREAMOFF, dir=-w
> (0x40045613) BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT,
> dir=rw (0xc0d05604) BT848 radio (STB, Gateway P/N 6: type=video-cap
> BT848 radio (STB, Gateway P/N 6: err:
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_G_FMT, dir=rw
> (0xc0d05604) v4l1-compat: VIDIOCSWIN / VIDIOC_G_FMT: -22
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_S_FMT, dir=rw
> (0xc0d05605) BT848 radio (STB, Gateway P/N 6: type=video-over
> BT848 radio (STB, Gateway P/N 6: err:
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_S_FMT, dir=rw
> (0xc0d05605) v4l1-compat: VIDIOCSWIN / VIDIOC_S_FMT #2: -22
> BT848 radio (STB, Gateway P/N 6: err:
> BT848 radio (STB, Gateway P/N 6: v4l2 ioctl VIDIOC_QUERYBUF, dir=rw
> (0xc0585609) v4l1-compat: VIDIOCSYNC / VIDIOC_QUERYBUF: -22
>
> I got no oops. The tests were done also on a 64bit kernel, on a dual-core
> machine.
>

My machine is a 2 x Opteron 244, 2GB RAM, MSI K Master 2FAR Board

bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv0: Bt878 (rev 17) at 0000:00:05.0, irq: 16, latency: 32, mmio: 0xfa015000
bttv0: using: Lifeview FlyVideo 98FM LR50 [card=56,insmod option]
bttv0: gpio: en=00000000, out=00000000 in=00e8ff00 [init]
bttv0: FlyVideo_gpio: unknown tuner type.
bttv0: FlyVideo Radio=yes RemoteControl=yes Tuner=-1 gpio=0xe8ff00
bttv0: FlyVideo  LR90=no  tda9821/tda9820=no  capture_only=no
bttv0: tuner type=1
bttv0: i2c: checking for MSP34xx @ 0x80... not found
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: registered device radio0
bttv0: PLL: 28636363 => 35468950 .. ok


lspci
00:00.0 Host bridge: VIA Technologies, Inc. VT8385 [K8T800 AGP] Host Bridge 
(rev 01)
00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge [K8T800/K8T890 
South]
00:05.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture 
(rev 11)
00:05.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 
11)
00:08.0 Multimedia audio controller: Creative Labs SB Audigy (rev 04)
00:08.1 Input device controller: Creative Labs SB Audigy Game Port (rev 04)
00:08.2 FireWire (IEEE 1394): Creative Labs SB Audigy FireWire Port (rev 04)
00:0b.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5705 Gigabit 
Ethernet (rev 03)
00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA RAID 
Controller (rev 80)
00:0f.1 IDE interface: VIA Technologies, Inc. 
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 81)
00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 81)
00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 81)
00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge 
[KT600/K8T800/K8T890 South]
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM 
Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM 
Controller
00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
01:00.0 VGA compatible controller: nVidia Corporation NV36 [GeForce FX 5700LE] 
(rev a1)


> Cheers,
> Mauro
>
> ---
>
> I've patched the ioctl-test program (at v4l2-apps/test dir, on v4l/dvb
> development environment, available at http://linuxtv.org/hg/v4l-dvb) with
> this diff:
>
> diff -r f24051885fe9 v4l2-apps/test/ioctl-test.c
> --- a/v4l2-apps/test/ioctl-test.c	Tue Mar 18 18:10:06 2008 -0300
> +++ b/v4l2-apps/test/ioctl-test.c	Sat Mar 22 21:52:16 2008 -0300
> @@ -47,6 +47,8 @@ typedef __u32 u32;
>   #else
>   typedef u_int32_t u32;
>   #endif
> +
> +#define CONFIG_VIDEO_V4L1_COMPAT
>
>   /* All possible parameters used on v4l ioctls */
>   union v4l_parms {
> @@ -142,7 +144,7 @@ int ioctls[] = {
>   	VIDIOCSYNC,/* int */
>   #endif
>   	/* V4L2 ioctls */
> -
> +#if 0
>   	VIDIOC_CROPCAP,/* struct v4l2_cropcap */
>   	VIDIOC_DQBUF,/* struct v4l2_buffer */
>   	VIDIOC_ENUMAUDIO,/* struct v4l2_audio */
> @@ -173,7 +175,7 @@ int ioctls[] = {
>   	VIDIOC_S_OUTPUT,/* int */
>   	VIDIOC_S_PARM,/* struct v4l2_streamparm */
>   	VIDIOC_TRY_FMT,/* struct v4l2_format */
> -
> +#endif
>   #if 0
>   	VIDIOC_G_AUDIO_OLD,/* struct v4l2_audio */
>   	VIDIOC_G_AUDOUT_OLD,/* struct v4l2_audioout */
> @@ -214,7 +216,7 @@ int main (void)
>   {
>   	int fd=0, ret=0;
>   	unsigned i;
> -	char *device="/dev/video0";
> +	char *device="/dev/radio0";
>   	union v4l_parms p;
>
>   	if ((fd = open(device, O_RDONLY)) < 0) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


