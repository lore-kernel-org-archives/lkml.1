Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbYAHTlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbYAHTlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYAHTk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:40:56 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:50707 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbYAHTky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:40:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=uUV2JKTGDiXDvVsf3+nwM1CZLZUxlPipicqqLEfmrqsV5bkQ9Mw06S3HM4awQ/8SScfwGttlLlWnLljbwoBv8YwomfSHL3q1Urhzr9RqYA6h425R8jnUVuUaaDIwOrQ3X806d/OtveqhUGq55+fbib/e3TLeeQbMtilEaS1Ct7c=
From: Mike Frysinger <vapier.adi@gmail.com>
Organization: ADI
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Date: Tue, 8 Jan 2008 14:40:49 -0500
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200801081329.39611.vapier.adi@gmail.com> <20080108202157.0b8d3393@poseidon.drzeus.cx>
In-Reply-To: <20080108202157.0b8d3393@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801081440.49683.vapier.adi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2008 14:21:57 Pierre Ossman wrote:
> Mike Frysinger <vapier.adi@gmail.com> wrote:
> > The on-chip Blackfin MMC/SD/SDIO host controller has the ability to do
> > 1-bit MMC, 1-bit/4-bit SD, and 1-bit/4-bit SDIO.  Thus the current
> > convention of MMC_CAP_4_BIT_DATA meaning "your host controller can do
> > 1-bit or 4-bit for all modes" is insufficient for our needs.  The
> > attached patch splits MMC_CAP_4_BIT_DATA into MMC_CAP_MMC_4_BIT_DATA and
> > MMC_CAP_SD_4_BIT_DATA and updates all host controllers to include these
> > in their caps and then changes existing code to check the new defines. 
> > At the moment, SD/SDIO are lumped into MMC_CAP_SD_4_BIT_DATA ... should I
> > bother with splitting that into SD and SDIO as well while I'm doing this
> > ?
> >
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
> I fail to see why you need to split MMC and SD. Could you elaborate why the
> controller won't work with MMC cards? I haven't seen any differences from
> SD.

i dont understand what's confusing.  the Blackfin on chip host controller only 
supports 1-bit MMC, but it supports 4-bit SD/SDIO.  this is a fact.  while it 
may be a stupid decision, it is what it is, and i need the framework made 
more flexible in order to get the Blackfin driver merged cleanly.  we do 
software for hardware, we dont do hardware.
-mike
