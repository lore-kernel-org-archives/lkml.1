Return-Path: <linux-kernel-owner+w=401wt.eu-S1030996AbXDYPNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030996AbXDYPNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031011AbXDYPNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:13:35 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:34220 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030996AbXDYPNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:13:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NqLv0RTirApwI9WWfUuEsAlLf+qCd5F1BPtWlT8KH3El7lf3sGQFrwZyKXanrC1DiQVFTCIM9Qra+kjne64PHbL26OtygDOTjl/16/BIPcZkSk9pqK5eItwHw1s9aBlHrs3MxxP2PV6TubxFpN9DCuAwiYx+BnW0vUXWUS+Y4ww=  ;
X-YMail-OSG: qr3DiEAVM1kvR4d0PM559v.GXU8OMRC1lnb7mpDoSVF7sgFoVoH8lHEj5hl8xydEI5I0eOTIqQ--
From: David Brownell <david-b@pacbell.net>
To: spi-devel-general@lists.sourceforge.net
Subject: Re: [spi-devel-general] adding bits_per_word to struct spi_board_info to mirror struct spi_device
Date: Wed, 25 Apr 2007 08:13:30 -0700
User-Agent: KMail/1.9.6
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, "Wu, Bryan" <Bryan.Wu@analog.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <8bd0f97a0704250305qe6175cdm8e1a0cd7844f67bc@mail.gmail.com>
In-Reply-To: <8bd0f97a0704250305qe6175cdm8e1a0cd7844f67bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704250813.30999.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 April 2007, Mike Frysinger wrote:
> the spi_device structure has a bits_per_word so that you can change
> the value on a per-device setting, yet the spi_board_info structure
> does not ... this means that the bus-specific structure has to have a
> bits_per_word member which the spi bus driver will copy into the spi
> device bits_per_word member

Actually that's more likely a driver-specific characteristic than
something related to board wiring/configuration ... a characteristic
of the particular protocol requests being made.  That's why for
example bits_per_word has a per-transfer override, and drivers are
able to call spi_setup(spi).


> is there something obvious i'm missing ?  seems to me that if the
> generic spi framework respects bits_per_word on a per-spi device
> basis, then it should be exposed in the generic info structure so that
> the setting can be tracked in the boards file ...

The initial driver set didn't need it, that's all.  ISTR someone
else pointed out this quirk, but never provided a patch to resolve
the issue.

- Dave
