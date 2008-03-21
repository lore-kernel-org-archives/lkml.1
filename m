Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbYCUJ43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbYCUJ43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 05:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYCUJ4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 05:56:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:41012 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbYCUJ4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 05:56:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=un1BsDid6vboHKEeLztJ4xvl9PGmxV7OU3+s5qkb5ilH1EyJ9M3hcKx0wVWNqWZKgTNODba30X7UZJNV+EDMMunbI4fgEChUmC0WKjW1w4VYZcq6DgL7APJkqnPhBrQOtzhGRoyKOeBVBMCfM6KqDn7qDJAeI9ZYU8hGynSuDO4=
Message-ID: <47E3863A.1010700@gmail.com>
Date: Fri, 21 Mar 2008 18:56:10 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: osb972ww-linuxczmil@yahoo.com
CC: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Fw: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <217535.99274.qm@web34505.mail.mud.yahoo.com>
In-Reply-To: <217535.99274.qm@web34505.mail.mud.yahoo.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

osb972ww-linuxczmil@yahoo.com wrote:
> setting irqpoll fixed both problems, and there are no "nasty grams"
> in dmesg now.   The original reason I was trying to use the hdparm -u
> on /dev/sda was because it was hanging for a few seconds when doing
> writes to the CFdisk, and in the past that was the kind of thing that
> hdparm -u would generally fix.

libata drivers don't need or support hdparm -u settings.

>  Now with the irqpoll kernel option,
> the /dev/sdb SATA drive was found, and I can mount it and write to
> it.  The CFcard /dev/sda is also responding to writes better than
> before.
> 
> Thanks for the suggestion to use irqpoll.    What is the problem
> within the driver(s) that is requiring irqpoll. ?

Well, IRQ 18 is taken offline during USB initialization.  The IRQ is
shared with the SATA controller, so SATA controller doesn't work either.
 It isn't clear why the IRQ handler is taken offline.  It could be the
USB controller but can also be the SATA controller.  Does not loading
usb driver make any difference?

-- 
tejun
