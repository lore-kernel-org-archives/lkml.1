Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbYA3Sxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbYA3Sxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756272AbYA3Sx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:53:27 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:29030 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbYA3Sx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:53:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=cwMgJPvnfgBrD9BdxpQPJccatGtiDl786tgDKcBSOM71l67b33LH6zW5aLhMzcm2WrUpZStxtfcKMAqdk4AAo5vEYb5ySg93BYEtI7PKmrCGMzFyCx53oMiTmektDdYKXHo4X2MIlmuwyqD0wfHqhQz6i8eJLS2AHCtK1CdOCyY=
Message-ID: <e9c3a7c20801301053p7279b660g8f967120d0d16bf5@mail.gmail.com>
Date: Wed, 30 Jan 2008 11:53:24 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [RFC v2 4/5] dmaengine: Driver for the Synopsys DesignWare DMA controller
Cc: linux-kernel@vger.kernel.org, "Shannon Nelson" <shannon.nelson@intel.com>,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
In-Reply-To: <1201630213-31900-5-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-2-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-4-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-5-git-send-email-hskinnemoen@atmel.com>
X-Google-Sender-Auth: 0215696e3d946f1f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 29, 2008 11:10 AM, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
[..]
> The dmatest client shows no problems, but the performance is not as
> good as it should be yet -- iperf shows a slight slowdown when
> enabling TCP receive copy offload. This is probably because the
> controller is set up to always do byte transfers; I'll try to optimize
> this, but if someone can tell me if there any guaranteed alignment
> requirements for the users of the DMA engine API, that would help a
> lot.
>

dmaengine punts to the dma-mapping api.  So no, there are no alignment
guarantees.  The performance loss is probably more related to the
cache synchronization overkill of get_user_pages().  I/O incoherent
architectures end up synchronizing entire pages when we only need to
sync a kilobyte or two in this path.

--
Dan
