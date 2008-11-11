Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbYKKOa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbYKKOa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 09:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbYKKOaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 09:30:13 -0500
Received: from sec.bit-consulting.com.ar ([200.69.255.76]:58274 "EHLO
	sec.bit-consulting.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbYKKOaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:30:12 -0500
From: "Diego M. Vadell" <dvadell@linuxclusters.com.ar>
Organization: Linuxclusters
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: PAT and MTRRs
Date: Tue, 11 Nov 2008 13:30:04 -0100
User-Agent: KMail/1.9.7
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <200810262246.21807.dvadell@linuxclusters.com.ar> <59727.163.10.1.174.1225492920.squirrel@sec.bit-consulting.com.ar> <490B963D.5010100@kernel.org>
In-Reply-To: <490B963D.5010100@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811111330.04624.dvadell@linuxclusters.com.ar>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> your bios doesn't cover 4g above RAM..
>
> please do
> 1. boot linux with "disable_mtrr_trim"
> 2. after booting input:
> echo "base=0x100000000 size=0x20000000 type=write-back" >/proc/mtrr
> echo "base=0x120000000 size=0x8000000 type=write-back" >/proc/mtrr
> echo "base=0x128000000 size=0x4000000 type=write-back" >/proc/mtrr
>
> later you could put those three lines in one scripts and call it from
> inittab # grep mtrrfixup /etc/inittab
> mtrrfixup:345:once:/root/mtrrfixup.sh
>
> YH
> --

Hi,

   It worked! It takes 10 minutes to boot, but it gets speedy somewhere in the 
booting process. I checked the memory speed with "stream" and its working.

   Just for the record, I had to change the line in /etc/inittab 
to "mtrr:345:once:/root/mtrrfixup.sh" or else, init would complain about the 
first field being more than 4 characters.

   Thank you very much

 -- Diego 
