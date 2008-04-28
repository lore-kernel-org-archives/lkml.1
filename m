Return-Path: <linux-kernel-owner+w=401wt.eu-S937587AbYD1TGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937587AbYD1TGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765235AbYD1TGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:06:30 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:50256 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933808AbYD1TG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:06:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U0QWRXPIYWSNOijRAlxlGgZkfnNL1cz96kVkiEi5sYStHHH8GSmaocz999uAEp5LUa63itDDwZAx+Riy1BX/CPdoeI/fJwBLIuSuylyYhIHplQ4Ebph89Zu3h75lyRFHuWwK0ggKM+Qfc0fOUEwbiLSpFm2amOhzGZfQuMDdMT4=
Message-ID: <86802c440804281206u6b5086a3h42192b7d36b08325@mail.gmail.com>
Date: Mon, 28 Apr 2008 12:06:26 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Cc: "Mika Fischer" <mika.fischer@zoopnet.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, balajirrao@gmail.com,
       "Andi Kleen" <andi@firstfloor.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <4815DE0C.6000802@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com>
	 <20080426035614.a30afb17.akpm@linux-foundation.org>
	 <48132665.8050202@googlemail.com>
	 <86802c440804272344yac6a9f0n40809169424247e6@mail.gmail.com>
	 <48159668.5010808@googlemail.com>
	 <86802c440804280234y5b38b4bds330fc1a6987202c5@mail.gmail.com>
	 <48159ECF.9020004@googlemail.com> <20080428135351.GF3973@elte.hu>
	 <4815DB15.4070908@zoopnet.de> <4815DE0C.6000802@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 7:24 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
> Mika Fischer wrote:
>  > Hi Ingo,
>  >
>  > I'm having the same problem.
>  >
>  > Ingo Molnar schrieb:
>  >> excellent. So just to make sure: this box never had proper graphics
>  >> under Linux (under no previous kernel), due to the way the BIOS has set
>  >> up the MTRR's, right?
>  >
>  > Well, not quite. X still works fine, but since the video memory is
>  > overlapped by two of the existing MTRRs, X cannot add a write-combining
>  > range for the video memory. That makes X rather slow especially if you
>  > use DRI for Compiz etc.
>
>  Well you are lucky then :)
>
>  Yeah X 'worked' but it worked as slow as with vesa video driver here.

[    0.000000] rangeX: 0000000000000000 - 00000000d0000000
[    0.000000] Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
[    0.000000] Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
[    0.000000] Setting variable MTRR 2, base: 3072MB, range: 256MB, type WB
[    0.000000] range0: 00000000cf800000 - 00000000cf800000
[    0.000000] range: 00000000cf800000 - 00000000d0000000
[    0.000000] Setting variable MTRR 3, base: 3320MB, range: 8MB, type WB
[    0.000000] range0: 0000000100000000 - 0000000120000000
[    0.000000] Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
[    0.000000] range: 0000000120000000 - 0000000130000000
[    0.000000] Setting variable MTRR 5, base: 4608MB, range: 256MB, type WB
[    0.000000] hole: 000000012c000000 - 0000000130000000
[    0.000000] Setting variable MTRR 6, base: 4800MB, range: 64MB, type UC

so your X server need two entries for WB?

can you send out /proc/mtrr with booting with disable_mtrr_cleanup?

YH
