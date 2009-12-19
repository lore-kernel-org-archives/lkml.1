Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbZLSMVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbZLSMVi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 07:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZLSMVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 07:21:37 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:58321 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbZLSMVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 07:21:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=WESwnADQuITpOBFPizabrNfbuRzYbFmXJOGr7OVoVHAFyCYhDnthff2GtsTCcw75Pk
         IX4hz/HPT6Q2FhVuYx1DRjzWhwRacpk08Kb1MKiAf4xTHrO3wHBMt41cn2ZdUovehqA2
         cu31pVpup7XrOe4h7OgRa2FuDk16YvrSsNArc=
Message-ID: <4B2CC54A.9020507@gmail.com>
Date: Sat, 19 Dec 2009 13:21:30 +0100
From: Martin Fuzzey <mfuzzey@gmail.com>
Reply-To: mfuzzey@gmail.com
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Portable drivers for 8 bit devices
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I recently posted a patch for the sc26xx serial driver (which is
currently only enabled for SNI_RM 32 bit MIPS), enabling it for all
architectures (and adding support for 268x devices). I tested this on ARM.

However I was contacted (off list) by someone trying to use the driver
on 64 bit MIPS.
Turned out this didn't work because the driver (both the current main
line and my patched version) assume the UART chip (which is a 8 bit
device) is mapped into a 32 bit port (ie the first 3 8 bit register
offsets are defined as):

#define WR_PORT_MRx 0x00
#define WR_PORT_CSR 0x04
#define WR_PORT_CR  0x08

On the 64 bit MIPS system (a CISCO router..) these offsets needed to be
doubled.

What is the best way to fix this properly? Some ideas:
1) Compile time #ifdef based on CPU bus size
2) Add a driver specific KConfig option for the address shift
3) Add an address shift element to platform data

I don't think #1 is the right solution since the port size is often
configurable (especially on SoCs) independently of the CPU bus size.
My preference is #3

Cheers,

Martin




