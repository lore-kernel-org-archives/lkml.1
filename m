Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYJWMWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYJWMWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 08:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYJWMWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 08:22:20 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:56276
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826AbYJWMWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 08:22:19 -0400
X-Trace: 151487464/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjMFAM8IAEnDlSwG/2dsb2JhbACBdr8Ng04
X-IronPort-AV: E=Sophos;i="4.33,470,1220223600"; 
   d="scan'208";a="151487464"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Robert Moss" <robert.von.moss@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Framebuffer issues in 2.6.26 with uvesafb and vesafb. Linux is about choice!
Date: Thu, 23 Oct 2008 13:22:15 +0100
User-Agent: KMail/1.10.1 (Linux/2.6.27-damocles; KDE/4.1.2; x86_64; ; )
Cc: "Samuel Thibault" <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org
References: <6ffd69180810230054s3b6aff5y880a898c3fc66a37@mail.gmail.com> <20081023080459.GC5073@const.bordeaux.inria.fr> <6ffd69180810230421v1508664bgc6e454cde792154f@mail.gmail.com>
In-Reply-To: <6ffd69180810230421v1508664bgc6e454cde792154f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810231322.15257.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2008 12:21:09 Robert Moss wrote:
> I also want to note, that I downloaded 2.6.27.3 and compiled, with
> CONFIG_FB_VESA=Y, and still get excactly the same response as from
> 2.6.26

Useful info, and I checked your configs and they enable the right options. 
Looks like you've found a real bug.

IIRC, a lot of real mode assembler (including the x86 vga/vesa stuff, iirc) 
was rewritten a year or so ago, in C. This might have been the time that this 
bug was introduced. I've added hpa to CC since I believe he was the author of 
these changes.

(Summary of the original report is that vga= vesa mode selection seems to have 
broken for Robert since at least 2.6.26, and after 2.6.24. From what I can see 
he has the right vesafb options enabled.)

> Screen unavailable [or not found, im not sure] 317.  (which i believe
> is 0x317 = 791)

I grepped the tree for "Screen unavailable" and "Screen not found" and found 
nothing. Could you please reproduce the message and confirm which exactly it 
is?

-- 
Cheers,
Alistair.
