Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbYLOJXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbYLOJXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 04:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYLOJW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 04:22:58 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:9035 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131AbYLOJW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 04:22:57 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Philipp Kohlbecher <xt28@gmx.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <49454749.2030901@gmx.de>
References: <49454749.2030901@gmx.de>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 09:22:34 +0000
Message-Id: <1229332954.25349.78.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] x86: documentation fix regarding boot protocol
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=SzA6YOMSqwYA:10 a=v75ATkktc-UA:10 a=B-iTP8YmfzJTdInPYUkA:9 a=MihhZElx3d1iKgXUw8UA:7 a=80aN9PdB53BtKTK49ip-81G1TC0A:4 a=LY0hPdMaydYA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-12-14 at 18:50 +0100, Philipp Kohlbecher wrote:
> Documentation/x86/boot.txt describes payload_offset as the offset
> from the end of the real-mode code. In fact, it is more accurately
> described as the offset from the beginning of the protected-mode
> code, as (a) this is how it is actually calculated and (b) the padding
> after the real-mode code is not included in the offset.
> 
> Signed-off-by: Philipp Kohlbecher <xt28@gmx.de>

Acked-by: Ian Campbell <ijc@hellion.org.uk>

The padding after the real-mode code which you mention is just the
implicit padding because the size of the real-mode code is specified in
sectors (and hence is rounded up), isn't it?

Is it worth saying that the payload_offset is relative to (setup_sectors
+1) * 512?

> 
> ---
> 
>   Documentation/x86/boot.txt |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
> index 83c0033..414b6fb 100644
> --- a/Documentation/x86/boot.txt
> +++ b/Documentation/x86/boot.txt
> @@ -537,8 +537,8 @@ Type:		read
>   Offset/size:	0x248/4
>   Protocol:	2.08+
> 
> -  If non-zero then this field contains the offset from the end of the
> -  real-mode code to the payload.
> +  If non-zero then this field contains the offset from the beginning
> +  of the protected-mode code to the payload.
> 
>     The payload may be compressed. The format of both the compressed and
>     uncompressed data should be determined using the standard magic
> 
-- 
Ian Campbell

* weasel wonders how stupid one has to be to spam alt.anonymous.messages
 weasel: about half as stupid as one has to be to harvest it.

