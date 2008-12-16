Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbYLPHNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbYLPHNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbYLPHNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:13:35 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:51641 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbYLPHNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:13:34 -0500
Message-ID: <49475516.3090504@freemail.hu>
Date: Tue, 16 Dec 2008 08:13:26 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: mschimek@gmx.at, video4linux-list@redhat.com
CC: LKML <linux-kernel@vger.kernel.org>, em28xx@mcentral.de
Subject: parameter of VIDIOC_G_INPUT and VIDIOC_S_INPUT?
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32710; Body=4 Fuz1=4
	Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a question about the parameter of VIDIOC_G_INPUT and VIDIOC_S_INPUT
parameters in v4l2 specification.

The "Video for Linux Two API Specification" text says that the
parameter of VIDIOC_G_INPUT and VIDIOC_S_INPUT is ...

> [...] a pointer to an integer where the driver stores the number
> of the input, as in the struct v4l2_input index field.
>
> http://v4l2spec.bytesex.org/spec/r11217.htm

In the v4l2_input structure the index has the type of __u32.

In contrast, in <linux/videodev2.h> (as of 2.6.27) the ioctls are defined
as follows:

> #define VIDIOC_G_INPUT		_IOR('V', 38, int)
> #define VIDIOC_S_INPUT		_IOWR('V', 39, int)

The problem is that '__u32' is unsigned and 'int' is signed. Furthermore
one cannot be sure that sizeof(__u32) == sizeof(int) on all platforms.

I guess that the parameter of VIDIOC_G_INPUT and VIDIOC_S_INPUT should be
a pointer to __u32. What do you think?

Regards,

	Márton Németh
