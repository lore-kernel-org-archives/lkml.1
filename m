Return-Path: <linux-kernel-owner+w=401wt.eu-S1759448AbZD1GvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448AbZD1GvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 02:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbZD1Gu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 02:50:58 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44107 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688AbZD1Gu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 02:50:57 -0400
X-Sasl-enc: Lo/MLbSVVp3mjimpwIUH67sOZmHkBFsN6ic79xyy0Qja 1240901456
Message-ID: <49F6A756.7070203@ladisch.de>
Date: Tue, 28 Apr 2009 08:51:02 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: NLS: utf8 conversions
References: <Pine.LNX.4.44L0.0904271144330.10904-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0904271144330.10904-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> Your comments agree pretty well with what I had concluded.  However a 
> lot of the source files have lengthy tables of wchar_t values; changing 
> them to 32 bits would waste a lot of space.
> 
> As a sort of compromise, I came up with this patch (not tested yet,
> although it compiles okay).  How does it look to you?

>From a not-having-it-tested-either perspective, it looks good.

> +utf8_to_utf32(unicode_t *p, const u8 *s, int n)
> +utf32_to_utf8(u8 *s, unicode_t u, int maxlen)
> +utf8s_to_utf16s(wchar_t *pwcs, const u8 *s, int n)
> +utf16s_to_utf8s(u8 *s, const wchar_t *pwcs, int maxlen, int inlen,

Minor nitpick: You already have enhanced the insane parameter ordering
of wcsntombs_be(), but the meaning of all these functions' parameters
would be even more obvious if the buffer size would immediately follow
the corresponding buffer pointer.

Anyway,
Acked-by: Clemens Ladisch <clemens@ladisch.de>


> +++ usb-2.6/fs/isofs/joliet.c
> ...
> -static int
> -wcsntombs_be(__u8 *s, const __u8 *pwcs, int inlen, int maxlen)
> -{
> ...
> -		} else {
> -			*op++ = (__u8) c;
> -		}

Just for the record: this function had the same buffer overflow bug as
utf8_wcstombs(), but it wasn't exploitable either.


Best regards,
Clemens
