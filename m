Return-Path: <linux-kernel-owner+w=401wt.eu-S934430AbXEHHav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934430AbXEHHav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 03:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933949AbXEHHav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 03:30:51 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:26949 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933876AbXEHHau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 03:30:50 -0400
X-IronPort-AV: i="4.14,503,1170651600"; 
   d="scan'208"; a="29346122:sNHT22208424"
Subject: Re: [spi-devel-general] adding bits_per_word to struct
	spi_board_info to mirror struct spi_device
From: Bryan WU <bryan.wu@analog.com>
To: David Brownell <david-b@pacbell.net>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       spi-devel-general@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200705072200.26888.david-b@pacbell.net>
References: <8bd0f97a0704250305qe6175cdm8e1a0cd7844f67bc@mail.gmail.com>
	 <8bd0f97a0705071647w58c6055ehc54dd6b520a8e227@mail.gmail.com>
	 <1178596106.5222.3.camel@roc-desktop>
	 <200705072200.26888.david-b@pacbell.net>
Content-Type: text/plain
Date: Tue, 08 May 2007 15:31:35 +0800
Message-Id: <1178609496.5222.24.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 22:00 -0700, David Brownell wrote:
> On Monday 07 May 2007, Bryan WU wrote:
> 
> > currently, there are some duplicated data members in spi_device struct
> > spi_board_info struct. This two structs are confused driver writers and
> > boards driver users.
> 
> How would that confusion arise?  Only arch/.../board-xxx.c writers
> normally even see spi_board_info; the exception is that someone who
> writes an add-on board -- maybe a USB-to-SPI adapter -- would call the
> rarely used spi_new_device() routine.
> 
> Developers writing a SPI drivers -- controller drivers touching some
> SOC's serial controller hardware, or "struct spi_driver" protocol code
> talking to a chip through such a controller -- never see board info.
> They only see "struct spi_device".  So I don't see why they would have
> a reason to be confused.
> 
> - Dave

Yes, I agree with you.
spi_board_info ---> board writers.
spi_device ---> spi device driver writers.

It is very clear for me, a spi_master driver developer.

But how does a board writer know the capabilities which the target
spi_device driver supports? For example, a board writer use 16
bits_per_word in a spi_board_info, while the spi_device does not support
this. And maybe other special function spi_device driver can provide but
board writer doesn't know or doesn't know how to use this in
spi_board_info.

So can we just use one struct for both board writers and spi device
driver developers?

Thanks
-Bryan Wu

