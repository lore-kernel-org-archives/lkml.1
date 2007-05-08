Return-Path: <linux-kernel-owner+w=401wt.eu-S967858AbXEHFAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967858AbXEHFAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 01:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967852AbXEHFAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 01:00:35 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:39898 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S967840AbXEHFAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 01:00:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rxRb6sonKn09GG4brsTMEmQwv/ncVIGb7JLymZb2otbN2YNZDF9O7VefFzyur0c0bBdudA/1X+Dqh3qE564TDaLyiSn7GatcTZxD7K0o1tKyg76YfIRqyFlVjm05NqdvaNQmDzFauyvTntgk1d5Y6ZegpwZX0IWMDPkd5G+JWv8=  ;
X-YMail-OSG: 8TYlDz8VM1nsDAfbTN8cK6.EHHfdLcMgRmkgyuRj2YiKHGwt7hlzndg_dSX3t0a_BRq.8BpCyA--
From: David Brownell <david-b@pacbell.net>
To: Bryan WU <bryan.wu@analog.com>
Subject: Re: [spi-devel-general] adding bits_per_word to struct spi_board_info to mirror struct spi_device
Date: Mon, 7 May 2007 22:00:26 -0700
User-Agent: KMail/1.9.6
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       spi-devel-general@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <8bd0f97a0704250305qe6175cdm8e1a0cd7844f67bc@mail.gmail.com> <8bd0f97a0705071647w58c6055ehc54dd6b520a8e227@mail.gmail.com> <1178596106.5222.3.camel@roc-desktop>
In-Reply-To: <1178596106.5222.3.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705072200.26888.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 May 2007, Bryan WU wrote:

> currently, there are some duplicated data members in spi_device struct
> spi_board_info struct. This two structs are confused driver writers and
> boards driver users.

How would that confusion arise?  Only arch/.../board-xxx.c writers
normally even see spi_board_info; the exception is that someone who
writes an add-on board -- maybe a USB-to-SPI adapter -- would call the
rarely used spi_new_device() routine.

Developers writing a SPI drivers -- controller drivers touching some
SOC's serial controller hardware, or "struct spi_driver" protocol code
talking to a chip through such a controller -- never see board info.
They only see "struct spi_device".  So I don't see why they would have
a reason to be confused.

- Dave

