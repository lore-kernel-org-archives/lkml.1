Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbXJHVkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbXJHVkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 17:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbXJHVkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 17:40:03 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:59004 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbXJHVj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 17:39:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=hgSwabDwUJRaVP+KrDKLuVUe66+RGS3JA64oF/2I2SQtYA8h8cKK33BZrYD671APVtz64zo/VyGF2ygQDBebyFeAi7XrUBOJS4Ay3zxdRC+qImdu7r2Ui3lUk92ZaO/W9Qrbmih2G+7Lifxm5qXOqKdWEPo7Qi+HXULCSF17pZI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Bug #4580: hda: lost interrupt when resuming from S3 - Sony VGN-T1XP
Date: Mon, 8 Oct 2007 23:44:45 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200710072217.07656.rjw@sisk.pl>
In-Reply-To: <200710072217.07656.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710082344.45377.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 07 October 2007, Rafael J. Wysocki wrote:
> Hi,
> 
> IDE/ATA wizzards are kindly requested to have a look at:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=4580#c21
> 
> as I have no idea of what we can do about the "hard drive password vs suspend"
> problem, if anything.

CONFIG_BLK_DEV_IDEACPI=y is not enough since IDE ACPI _GTF support is disabled
by default.  To enable it "ide=acpigtf" kernel parameter should be used.

Sometimes it may be also worth to try enabling usage of IDE ACPI methods on
boot ("ide=acpionboot" kernel parameter) which is also disabled by default.

We probably should switch both options to be on by default if recent libata
transition to ACPI on by default turns out to be successful.

PS I've updated bug #4580 accordingly.

Thanks,
Bart
