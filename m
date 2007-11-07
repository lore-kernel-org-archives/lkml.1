Return-Path: <linux-kernel-owner+w=401wt.eu-S1759403AbXKGRzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403AbXKGRzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbXKGRyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:54:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44752 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbXKGRyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:54:52 -0500
Message-ID: <4731FBAA.9020500@zytor.com>
Date: Wed, 07 Nov 2007 09:53:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pxeboot broken by commit "x86 setup: handle boot loaders which
 set up the stack incorrectly"
References: <200711070708.lA778VtP029664@terminus.zytor.com> <86802c440711070949pc09d49ar36d0b9f32a506e20@mail.gmail.com>
In-Reply-To: <86802c440711070949pc09d49ar36d0b9f32a506e20@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> good to know. everyone need to update to 3.52 now...
> but i still can not understand why that mcp55 system works but the
> ck804 based doesn't on 3.10
> 

The bug is that syslinux incorrectly positions the stack above the 
command line (but not the stack pointer register; hence the kernel patch 
exposing this bug.)  So the stack plus command line end up being limited 
  to 512 bytes; how much stack gets used depends on the BIOS, so one 
BIOS may use a lot more than another.

	-hpa
