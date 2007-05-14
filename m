Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbXENGVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbXENGVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 02:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760653AbXENGVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 02:21:36 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:7501 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759581AbXENGVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 02:21:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mQKPcVIfS2r3dV5uJ67/x6tI/ogNd0jTLEGJQPdjVoWh5ySztZMxMJfbIbtLonBvi6ol8N99IQAt10jdZ0s3Qqwwkv/eBz8q/eCEkomyAPrEwN2hN3KzBpEl6W9tLZXzI5FWAU3kwAQOXd866ZBpiFeNGvEmzvDA2vRIVADUIKU=
Message-ID: <a781481a0705132321q14edf12at47429923d1d1490c@mail.gmail.com>
Date: Mon, 14 May 2007 11:51:33 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: Linux 2.6.22-rc1
Cc: tilman@imap.cc, linux-kernel@vger.kernel.org
In-Reply-To: <20070513.162059.78710763.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	 <4647569D.7010709@imap.cc>
	 <20070513.162059.78710763.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 5/14/07, David Miller <davem@davemloft.net> wrote:
> From: Tilman Schmidt <tilman@imap.cc>
> Date: Sun, 13 May 2007 20:19:09 +0200
>
> > Would it be asking too much to have help texts on the following
> > new (wrt 2.6.21) configuration options?
> >
> > ESP Scsi Driver Core (SCSI_ESP_CORE) [N/m] (NEW)
>
> This one is a case where the option makes no sense by itself,
> it provides the core common code for other front-end drivers.
>
> The documentation exists in those front end drivers, which
> in turn auto-matically select and enable this config option.
>
> It would be nice if there was a Kconfig way to not provide
> this thing at all unless one of the front-ends got selected

Yeah, so the Kconfig-blessed way that you're looking for is:

config SCSI_ESP_CORE
	tristate
	depends on SCSI && SCSI_SPI_ATTRS
	default y if SCSI_SUNESP=y
	default m if SCSI_SUNESP=m

Add other front-ends (other than SCSI_SUNESP) to the last
two lines, as applicable.

Important: And then *remove* the "select SCSI_ESP_CORE"
from the Kconfig options of the front-ends themselves.

[ You could do something similar with SCSI_SPI_ATTRS
also, it looks like to be something that probably never makes
sense alone either, and needs only to be automatically pulled
in by other options (?) ]

[ Note that "select"ing stuff that is not library-like and itself
depends on other stuff is a Bad Thing. ]

> but on the otherhand I like how anyone can select it and thus
> test the build of it :-)

Satyam
