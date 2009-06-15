Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbZFOHP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbZFOHP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 03:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbZFOHPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 03:15:42 -0400
Received: from sirius.lasnet.de ([78.47.116.19]:57085 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823AbZFOHPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 03:15:41 -0400
Date: Mon, 15 Jun 2009 09:15:37 +0200
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: Brian Swetland <swetland@google.com>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       pavel@ucw.cz
Message-ID: <20090615071537.GA2029@excalibur.local>
References: <1245033557-10968-1-git-send-email-swetland@google.com> <1245033557-10968-2-git-send-email-swetland@google.com> <1245033557-10968-3-git-send-email-swetland@google.com> <1245033557-10968-4-git-send-email-swetland@google.com> <20090615064234.GA1221@excalibur.local> <a55d774e0906142351o67b2388dnf26be72815fc3edf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a55d774e0906142351o67b2388dnf26be72815fc3edf@mail.gmail.com>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.19 (2009-01-05)
Subject: Re: [PATCH 3/3] [ARM] msm: add minimal board file for HTC Dream
	device
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Sun, 2009-06-14 at 23:51, Brian Swetland wrote:
> On Sun, Jun 14, 2009 at 11:42 PM, Stefan
> Schmidt<stefan@datenfreihafen.org> wrote:
> >> +
> >> +#include <linux/mtd/nand.h>
> >> +#include <linux/mtd/partitions.h>
> >
> > I see nothing in this file that needs mtd header files. Leftover from the "big"
> > machine file? Please aslo check if the other header files are needed.
> >
> >> +#include "devices.h"
> >> +#include "board-dream.h"
> >> +
> >> +static struct resource smc91x_resources[] = {
> >> +     [0] = {
> >> +             .start  = 0x9C004300,
> >> +             .end    = 0x9C004400,
> >> +             .flags  = IORESOURCE_MEM,
> >> +     },
> >> +     [1] = {
> >> +             .start  = MSM_GPIO_TO_INT(49),
> >> +             .end    = MSM_GPIO_TO_INT(49),
> >> +             .flags  = IORESOURCE_IRQ,
> >> +     },
> >> +};
> >> +
> >> +static struct platform_device smc91x_device = {
> >> +     .name           = "smc91x",
> >> +     .id             = 0,
> >> +     .num_resources  = ARRAY_SIZE(smc91x_resources),
> >> +     .resource       = smc91x_resources,
> >> +};
> >
> > I'm a bit confused here. The dream is the T-Mobile G1 and the Android dev phone,
> > right? Is there really a network chip connected inside the device? Or is this a
> > leftover from the developer board?
> 
> Oops.  Yeah that's definitely not present on G1.  I did a quick trim
> from the halibut (qualcomm dev board) board file to get to a sane
> starting point, but obviously didn't trim enough.

OK, I have no ADP hardware to help run time testing the code, but that one
looked to odd to me. :)

> Reconstructing the board files a little at a time as peripherals are
> added in various patch sets is going to be tedious, but probably a
> good opportunity to clean them up a bit.

Yeah, a problem I know pretty well. For my latest work on the Samsung Omnia I
started with sending patches right from the beginning, even if only PWM, fb and
mmc/sd works, to avoid the restructering over and over again afterwards.

regards
Stefan Schmidt
