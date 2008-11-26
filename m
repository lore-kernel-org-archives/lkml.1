Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbYKZBVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbYKZBVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 20:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYKZBUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 20:20:54 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:30235 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbYKZBUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 20:20:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OV/tC1IvBkH1ci6agU9UK0yHBJHgBL8i8aLbJmleB25IDJZFd34FwJJO9f70FgbMBl
         9dV0br6K7rZActiDk8RxQUEjcj03Vcm3vNJwfcQSmN+Wl7W5RljaW6WEPTGyau2MogHY
         qThFdTgU5jpPMKIhu2VYskL/3+6+HMqL0gz78=
Message-ID: <f17812d70811251720u47bec50dt3734f5b2bb0d339@mail.gmail.com>
Date: Wed, 26 Nov 2008 09:20:51 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Cc: "David Brownell" <dbrownell@users.sourceforge.net>,
       "David Brownell" <david-b@pacbell.net>,
       "Sam Ravnborg" <sam@ravnborg.org>, "Jean Delvare" <khali@linux-fr.org>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 6:52 AM, Jaya Kumar <jayakumar.lkml@gmail.com> wrote:
> Beloved friends,
>
> I would like to request your feedback on the following idea. I hope I have
> made sure to CC all the right people and the right lists! If not, PLEASE
> let me know! I couldn't find a MAINTAINERS entry for gpiolib so I just
> used what I saw in the git log and have also added people and lists that
> I think may be interested.
>
> This is just an RFC. If you all feel it is looking like the right approach
> then I'll clean it up and make it a patch.
>
> Thanks,
> jaya
>
> am300epd was doing 800*600*16*gpio_set_value for each framebuffer transfer
> (it uses 16-pins of gpio as its data bus). I found this caused a wee
> performance limitation. This patch adds an API for gpio_set_value_bus
> which allows users to set batches of consecutive gpio together in a single
> call. I have done a test implementation on gumstix (pxa255) with am300epd
> and it provides a nice improvement in performance.

Using a bit mask will be more generic if the GPIOs are not contiguous.
Yet I still doubt this will be generic enough to be added to gpiolib.
The user of this gpio_set_value_bus() may assume too much about
the internal, e.g. how many GPIOs on the chip and whether these GPIOs
are contiguous or not, and whether this GPIO chip support bitwise
operations.

Let's have a concrete example: what if the user gives a bunch of GPIOs
that crosses the chip boundary, say, GPIO29 - GPIO35 (with each chip
covering 32 GPIOs).
