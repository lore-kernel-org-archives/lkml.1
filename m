Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbZBBHM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbZBBHM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 02:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbZBBHMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 02:12:19 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:53858 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbZBBHMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 02:12:18 -0500
Message-ID: <49869CCE.9030906@freemail.hu>
Date: Mon, 02 Feb 2009 08:12:14 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28 + Trust 610 LCD PowerC@m Zoom, webcam mode?
References: <49856A54.1020105@freemail.hu> <20090201152435.0e06e42e@free.fr>
In-Reply-To: <20090201152435.0e06e42e@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32710; Body=3 Fuz1=3
	Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean-Francois Moine wrote:
> On Sun, 01 Feb 2009 10:24:36 +0100
> Németh Márton <nm127@freemail.hu> wrote:
>> Hello Jean-Francois,
> 
> Hello Márton,
> 
>> I have a Trust 610 LCD PowerC@m Zoom camera which can operate in
>> webcam mode also (USB ID=06d6:0031). I tried to use it together with
>> Linux 2.6.28 and with xawtv-3.95.dfsg.1 and with gqcam 0.9.1.
>> The /dev/video0 appeared, but no usable picture was visible.
>>
>> However, I downloaded
>> http://mxhaard.free.fr/spca50x/Download/gspcav1-20071224.tar.gz and
> 	[snip]
>> Do you have any idea why the gspcav1 diver is working and the one
>> which is included in Linux 2.6.28 not?
> 
> The gspcav1 is not maintained anymore.
> 
> It seems that your webcam has not been tested with gspcav2.

Yes, I found your status at page http://moinejf.free.fr/webcam.html .

> First, did you use the v4l library and its wrapper when running xawtv
> and gqcam?

I don't really know, I just installed the xawtv package coming with Debian.

> Then, have you tried my program svv?

I could get the Trust 610 LCD PowerC@m Zoom's webcam mode working with
2.6.28 by doing the following steps:
1. download and compile http://people.atrpms.net/~hdegoede/libv4l-0.5.8.tar.gz
2. download and compile http://moinejf.free.fr/svv.c
3. export LD_LIBRARY_PATH=./libv4l-0.5.8/libv4lconvert/
4. run svv

I tested the following settings, all were working correctly:
$ ./svv
raw pixfmt: JPEG 464x480
pixfmt: RGB3 464x480
mmap method
$ ./svv -m r
raw pixfmt: JPEG 464x480
pixfmt: RGB3 464x480
read method
$ ./svv -m u
raw pixfmt: JPEG 464x480
pixfmt: RGB3 464x480
userptr method

What I recognised is that the gspcav1 with xawtv delivered pictures
in resolution of 288x384, while the version in 2.6.28 in 464x480. I
guess this is an improved resolution, but I don't know why the aspect
ratio changed (288/384 = 3/4 = 0.75, 464/480 = 29/30 = 0.9667).

Thanks for your help!

Regards,

	Márton Németh

The output of v4l-info:

### v4l2 device info [/dev/video0] ###
general info
    VIDIOC_QUERYCAP
        driver                  : "sunplus"
        card                    : "Trust 610 LCD POWERC@M ZOOM"
        bus_info                : "0000:00:10.0"
        version                 : 2.3.0
        capabilities            : 0x5000001 [VIDEO_CAPTURE,READWRITE,STREAMING]

standards

inputs
    VIDIOC_ENUMINPUT(0)
        index                   : 0
        name                    : "sunplus"
        type                    : CAMERA
        audioset                : 0
        tuner                   : 0
        std                     : 0x0 []
        status                  : 0x0 []

video capture
    VIDIOC_ENUM_FMT(0,VIDEO_CAPTURE)
        index                   : 0
        type                    : VIDEO_CAPTURE
        flags                   : 1
        description             : "JPEG"
        pixelformat             : 0x4745504a [JPEG]
    VIDIOC_G_FMT(VIDEO_CAPTURE)
        type                    : VIDEO_CAPTURE
        fmt.pix.width           : 464
        fmt.pix.height          : 480
        fmt.pix.pixelformat     : 0x4745504a [JPEG]
        fmt.pix.field           : NONE
        fmt.pix.bytesperline    : 464
        fmt.pix.sizeimage       : 84110
        fmt.pix.colorspace      : JPEG
        fmt.pix.priv            : 1

controls
    VIDIOC_QUERYCTRL(BASE+0)
        id                      : 9963776
        type                    : INTEGER
        name                    : "Brightness"
        minimum                 : 0
        maximum                 : 255
        step                    : 1
        default_value           : 0
        flags                   : 0
    VIDIOC_QUERYCTRL(BASE+1)
        id                      : 9963777
        type                    : INTEGER
        name                    : "Contrast"
        minimum                 : 0
        maximum                 : 255
        step                    : 1
        default_value           : 32
        flags                   : 0
    VIDIOC_QUERYCTRL(BASE+2)
        id                      : 9963778
        type                    : INTEGER
        name                    : "Color"
        minimum                 : 0
        maximum                 : 255
        step                    : 1
        default_value           : 26
        flags                   : 0

### video4linux device info [/dev/video0] ###
general info
    VIDIOCGCAP
        name                    : "Trust 610 LCD POWERC@M ZOOM"
        type                    : 0x1 [CAPTURE]
        channels                : 1
        audios                  : 0
        maxwidth                : 464
        maxheight               : 480
        minwidth                : 48
        minheight               : 32

channels
    VIDIOCGCHAN(0)
        channel                 : 0
        name                    : "sunplus"
        tuners                  : 0
        flags                   : 0x0 []
        type                    : CAMERA
        norm                    : 0

tuner
ioctl VIDIOCGTUNER: Invalid argument

audio
ioctl VIDIOCGAUDIO: Invalid argument

picture
    VIDIOCGPICT
        brightness              : 32896
        hue                     : 0
        colour                  : 6168
        contrast                : 8224
        whiteness               : 0
        depth                   : 8
        palette                 : unknown

buffer
ioctl VIDIOCGFBUF: Invalid argument

window
    VIDIOCGWIN
        x                       : 0
        y                       : 0
        width                   : 464
        height                  : 480
        chromakey               : 0
        flags                   : 0


