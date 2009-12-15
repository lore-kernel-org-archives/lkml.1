Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbZLOMRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbZLOMRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 07:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760097AbZLOMR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 07:17:28 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45929 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760021AbZLOMR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 07:17:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=pZD/sPe858jZ6z9mURucKFxCXABe+SgNNK311dWouxktYOl18Fl4gCRfhNQs+ZQmiC
         UAUtDeOjpQ/e/1Fq5OMIir61VNyWH0v+/IqcajG/y3QtfgxwLE0nCuSGdK0XUanvGgWa
         1JQKtoCfIMIYRi2sBsgHyaDeym0dKVhycJYLg=
Date: Tue, 15 Dec 2009 13:17:21 +0100
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add support for Sphairon Homelink 1202 USB WLAN
Message-ID: <20091215131721.4cfbb28c@strolchi.home.s3e.de>
In-Reply-To: <20091211233709.29fc5312@strolchi.home.s3e.de>
References: <1260282095-17042-1-git-send-email-stefan.seyfried@googlemail.com>
	<20091211133603.46bec686@strolchi.home.s3e.de>
	<20091211144221.GA6663@tuxdriver.com>
	<20091211160124.4db2da76@strolchi.home.s3e.de>
	<1260559270.6254.2.camel@localhost.localdomain>
	<20091211233709.29fc5312@strolchi.home.s3e.de>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.1; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009 23:37:09 +0100
Stefan Seyfried <stefan.seyfried@googlemail.com> wrote:
> On Fri, 11 Dec 2009 11:21:10 -0800
> Dan Williams <dcbw@redhat.com> wrote:
> > place to put this code is probably unusual_devs instead of
> > touching /two/ drivers.  I'd say extract the code from zd1211rw and put
> > the new code that works for both zd1211rw/ar9170 into unusual_devs.  In
> > fact, people might be happier if you posted two patches, (1) move the
> > code to unusual_devs unchanged,

Done. Was easier than I had expected and resulted in a nice reduction
in lines of code, because usb storage code has all infrastructure to
handle the device, which zd1211rw had hand-crafted.

> and (2) fix up the moved code to support
> > the new device's behavior.

This was actually not necessary, because the usb-storage infrastructure
automatically chooses the correct endpoint :-)

See the mail
Subject: [PATCH] move eject code from zd1211rw to usb-storage

Thanks for review and suggestions,

	Stefan

-- 
"You sure you software suspend guys haven't been hanging out with the
 IDE maintainers?"     -- Rob Landley, during one of the suspend wars
