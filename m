Return-Path: <linux-kernel-owner+w=401wt.eu-S1765062AbXEYVmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765062AbXEYVmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759135AbXEYVmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:42:09 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:54883 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbXEYVmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:42:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=K246CAeNU5/i9tPoX6hVgk3c+zvVIetZlhJZRLN/onObgMu+FqvDqSMdKyXxJ8qZgCBtkulO0E/tkVI2d9xi60qbVUk8KiNzt/WXAy+64Sr0FkLfPanWWJoYG/hAT2ookKr0YSsLkGwLn7JYEyyXo8asArzy0qYYvkjpWOCgDXE=
Subject: Re: Nvidiafb issues on Inspiron 8100
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200705240137.35955.dtor@insightbb.com>
References: <200705240137.35955.dtor@insightbb.com>
Content-Type: text/plain
Date: Sat, 26 May 2007 05:42:01 +0800
Message-Id: <1180129321.4627.17.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 01:37 -0400, Dmitry Torokhov wrote:
> Hi Antonino,
> 
> I am having the following issues on my Dell Inspiron 8100. They are not
> new but I just got around to report them.
> 
> With CONFIG_FB_NVIDIA_I2C I get 1600x1200 resolution but pixels
> "swarming" and it is unuseable. There are following messages in
> dmesg (note complaints from i2c):

Looks like an EDID block not accessible by i2c and only available
through the BIOS. And it's probably broken too.

Can you #define DEBUG in drivers/video/fbmon.c, enable
CONFIG_FIRMWARE_EDID, the post your dmesg?

For now, the best you can do is disable i2c support and add:

video=nvidiafb:1600x1200@60

in your boot line.

Tony



