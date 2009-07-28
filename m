Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbZG1LdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbZG1LdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 07:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZG1LdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 07:33:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:53227 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbZG1LdR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 07:33:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gwVYUfzI346s+y0km2VDHhR5mp+u9Hh8pgxxoKIX1lMsQYl7FoERa6uOiv/Y5wfdXS
         kh+a075ezCQWyTyVO56yFWv74Mo8g3oISWfPg1abgRuz3mM+OKZvY/NP0gzwtF8Y6yPS
         qoS1YMEBc8Kv5ybgui5sKHdoTUKNYPmXjiKjU=
MIME-Version: 1.0
In-Reply-To: <200907280043.51688.rjw@sisk.pl>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
	 <3zAHs5O6maO.A.gfC.QHObKB@chimera>
	 <20090727091623.GA16229@yamamaya.is-a-geek.org>
	 <200907280043.51688.rjw@sisk.pl>
Date: Tue, 28 Jul 2009 14:33:16 +0300
Message-ID: <c70ff3ad0907280433n528a2078tfd0bcf8be5be4b24@mail.gmail.com>
Subject: Re: [Bug #13833] Kernel Oops when trying to suspend with ubifs 
	mounted on block2mtd mtd device
From: saeed bishara <saeed.bishara@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Woodhouse <David.Woodhouse@intel.com>
Cc: Tobias Diedrich <ranma@tdiedrich.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>, Eric Miao <eric.y.miao@gmail.com>,
       Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
This patch crashes my system, when issue suspend to ram, the kernel
crashes mtd_cls_suspend when the mtd device is mtdXro, the problem is
the the mtdXro devices are of mtd_class, and the suspend function of
this class assumes that the "dev" is contained in mtd_into structure
(dev_to_mtd(dev)), but, the mtdXro device created using
device_create() so the dev is not contained in valid mtd_info
structure.

saeed


On Tue, Jul 28, 2009 at 1:43 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> On Monday 27 July 2009, Tobias Diedrich wrote:
>> Rafael J. Wysocki wrote:
>> > This message has been generated automatically as a part of a report
>> > of recent regressions.
>> >
>> > The following bug entry is on the current list of known regressions
>> > from 2.6.30.  Please verify if it still should be listed and let me know
>> > (either way).
>>
>>
>> Well, the patch reverting the commit still applies to 2.6.31-rc4, so
>> I assume the issue persists,but I have not tried an unpatched
>> 2.6.31-rc4.
>
> Thanks for the update.
>
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
