Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbZAVL5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbZAVL5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 06:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZAVL4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 06:56:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59931 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZAVL4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 06:56:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 02/10] sdhci: Add support for bus-specific IO memory accessors
Date: Thu, 22 Jan 2009 12:55:48 +0100
User-Agent: KMail/1.9.9
Cc: Pierre Ossman <drzeus-sdhci@drzeus.cx>, Ben Dooks <ben-linux@fluff.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, Xie Xiaobo <X.Xie@freescale.com>,
       Konjin Lai <Konjin.Lai@freescale.com>,
       "Joe D'Abbraccio" <Joe.D'abbraccio@freescale.com>,
       sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
References: <20090122015649.GA6835@oksana.dev.rtsoft.ru> <20090122020019.GB11492@oksana.dev.rtsoft.ru>
In-Reply-To: <20090122020019.GB11492@oksana.dev.rtsoft.ru>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901221255.49724.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19lg9aOuR+aS0d2CA8BBkJxu3hxdM/UCjwZBgn
 KG0DzzPt5kJkYKYEpJLzYrBChdr87EyHVOG0Nw44YjT6C/SMkF
 FkoObnZkY5r7kywDFHv1Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 January 2009, Anton Vorontsov wrote:
> +       /*
> +        * These accessors duplicate sdhci_ops, but there are two reasons for
> +        * this:
> +        * 1. sdhci_ops are const, so the sdhci driver won't able to assign
> +        *    default ops;

You could assign the pointer to a const default_sdhci_ops structure,
which IMHO would be cleaner than copying the function pointers
separately.

> +        * 2. Using host->X instead of host->ops->X saves us one dereference.
> +        *    This can be useful in PIO mode. (Though the benefit of this
> +        *    is negligibly small).
> +        */

I doubt that this is even measurable. If it was, you could still use a copy
of that structure, like

struct sdhci_host {
	...
	struct sdhci_ops ops; /* not struct sdhci_ops *ops */
	...
};

and do an assignment of the structure, like

static void assign_ops(struct sdhci_host *host, struct sdhci_ops *ops)
{
	host->ops = *ops;
}

	Arnd <><
