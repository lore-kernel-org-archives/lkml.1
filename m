Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830Ab0AHPYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab0AHPYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505Ab0AHPYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:24:51 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:57816 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab0AHPYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:24:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dMwkgIIIC1Yet0e+gLlwhBgrqwf5BxsxVHQGeoZgP1+RRLOi0S/2tH92xz95+c5lpX
         V/wOa4q1dH+9DaP7mgqYH9+ouKe2ElJ9+nm8URic7e+dbUO5w7NT4MKDgmwcVYAT835h
         iXX9XWPcSpuRgmF6RRCqJoh2YKEUgdGKFb9hw=
Subject: Re: [PATCH v2] port ricoh_mmc to be pci quirk
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Philip Langdale <philipl@overt.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pierre Ossman <pierre@ossman.eu>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091126235551.2db699e3@fido2.homeip.net>
References: <1259021583.16650.9.camel@maxim-laptop>
	 <20091123162119.3777e14d@fido2.homeip.net>
	 <1259160947.10147.1.camel@maxim-laptop>
	 <1259161121.10147.4.camel@maxim-laptop>
	 <20091125085324.1ef9ae1f@fido2.homeip.net>
	 <20091125113501.1f4d42b9.akpm@linux-foundation.org>
	 <1259192401.15916.48.camel@maxim-laptop>
	 <20091125173019.74d0ddb9@fido2.homeip.net>
	 <1259279520.3991.5.camel@maxim-laptop>
	 <1259279584.3991.6.camel@maxim-laptop>
	 <20091126235551.2db699e3@fido2.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 17:24:44 +0200
Message-ID: <1262964284.12577.27.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 23:55 -0800, Philip Langdale wrote: 
> On Fri, 27 Nov 2009 01:53:04 +0200
> Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > >From 2d3002e29c329d76ca4e26d9f427814151a9648c Mon Sep 17 00:00:00
> > >2001
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Date: Fri, 27 Nov 2009 00:53:28 +0200
> > Subject: [PATCH] port ricoh_mmc to be pci quirk
> > 
> > This patch solves nasty problem original driver has.
> > Original goal of the ricoh_mmc was to disable this device because
> > then, mmc cards can be read using standard SDHCI controller,
> > thus avoiding writing of yet another driver.
> > However, the act of disablement, makes other pci functions that
> > belong to this controller (xD and memstick) shift up one level, thus
> > pci core has now wrong idea about these devices.
> > 
> > To fix this issue, this patch moves the driver into pci quirk
> > section, thus it is executes before the pci is enumerated, and
> > therefore solving that issue, also same sequence of commands is
> > performed on resume for same reasons.
> > 
> > Also regardless of the above, this way is cleaner.
> > 
> > You still need to set CONFIG_MMC_RICOH_MMC
> > to enable this quirk
> 
> I like it. Only comment is that I'd like the printks to identify which
> controller is involved. If Andrew is happy with the CONFIG mechanism,
> then you've got an ack from me.
> 
> Thanks for doing this.

Hi, do you plan to include this patch in the kernel?

BTW, I did write successfully the driver for the xD controller, so now
this is a real problem.

Best regards,
Maxim Levitsky

