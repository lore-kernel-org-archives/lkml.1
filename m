Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbYLPICG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbYLPICG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 03:02:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYLPIBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 03:01:54 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:47178 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbYLPIBy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 03:01:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eyrAfY6m2YDYKH6WuEssEVTepDea45CS/hpG7qVZEK3RtkgqOBoVKtJ2ougq0SKVzw
         mt81ph2F8wANhO4Cy2JtPD+S1g4Qt1l25nCusrwobHb7DMw9R3HtYDqGXNRWKz5NYe4n
         wvgiRPJMuXBti4wZJTika7MQhbbWHbFMbupxI=
Message-ID: <d9def9db0812160001x49f2a8c7udb11f35f6e1a27c9@mail.gmail.com>
Date: Tue, 16 Dec 2008 09:01:51 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "=?ISO-8859-1?Q?N=E9meth_M=E1rton?=" <nm127@freemail.hu>
Subject: Re: [Em28xx] parameter of VIDIOC_G_INPUT and VIDIOC_S_INPUT?
Cc: mschimek@gmx.at, video4linux-list@redhat.com,
       LKML <linux-kernel@vger.kernel.org>, em28xx@mcentral.de
In-Reply-To: <49475516.3090504@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <49475516.3090504@freemail.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/12/16 Németh Márton <nm127@freemail.hu>:
> Hi,
>
> I have a question about the parameter of VIDIOC_G_INPUT and VIDIOC_S_INPUT
> parameters in v4l2 specification.
>
> The "Video for Linux Two API Specification" text says that the
> parameter of VIDIOC_G_INPUT and VIDIOC_S_INPUT is ...
>
>> [...] a pointer to an integer where the driver stores the number
>> of the input, as in the struct v4l2_input index field.
>>
>> http://v4l2spec.bytesex.org/spec/r11217.htm
>
> In the v4l2_input structure the index has the type of __u32.
>
> In contrast, in <linux/videodev2.h> (as of 2.6.27) the ioctls are defined
> as follows:
>
>> #define VIDIOC_G_INPUT                _IOR('V', 38, int)
>> #define VIDIOC_S_INPUT                _IOWR('V', 39, int)
>
> The problem is that '__u32' is unsigned and 'int' is signed. Furthermore
> one cannot be sure that sizeof(__u32) == sizeof(int) on all platforms.
>
> I guess that the parameter of VIDIOC_G_INPUT and VIDIOC_S_INPUT should be
> a pointer to __u32. What do you think?
>

seems to be sane yes. This ioctl is also handled in compat_ioctl32.c and might
also get some attention there.

Markus
