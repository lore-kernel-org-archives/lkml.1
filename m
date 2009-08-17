Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbZHQIAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbZHQIAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757203AbZHQIAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:00:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:13738 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157AbZHQIAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:00:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=wNHIZ54YuR2r1YKgVOcka/INIls9xoles1Boffsq/QfXzinLhjR6LywTWcGpV+oYyM
         hkpkn6Yxujp/gfdE53ldlgeBUwt45HEiFyQrIyXHWy8k5545ZbSZlH2wjf5sVnYxg2No
         /ZRbVehttmWySE0PacIWKtbgNY+T70H2DrfuA=
Message-ID: <4A890E33.2080302@gmail.com>
Date: Mon, 17 Aug 2009 10:00:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-7.4 Thunderbird/3.0b3
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: akpm@linux-foundation.org, andi@firstfloor.org, rpjday@crashcourse.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] VIDEO: console, use DIV_ROUND_UP
References: <20090817073147.GA2967@localdomain.by> <1250495293-13035-1-git-send-email-jirislaby@gmail.com> <20090817080023.GB2967@localdomain.by>
In-Reply-To: <20090817080023.GB2967@localdomain.by>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2009 10:00 AM, Sergey Senozhatsky wrote:
> So... In general, ((vc->vc_font.width + 7) >> 3) ==  DIV_ROUND_UP(vc->vc_font.width, 8) - 1;

?

#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))

DIV_ROUND_UP(vc->vc_font.width, 8) expands to:
(((vc->vc_font.width) + (8) - 1) / (8))
which is pretty printed:
(vc->vc_font.width + 7) / 8
and that's equivalent to:
(vc->vc_font.width + 7) >> 3

Correct?

> Are you sure we really can use DIV_ROUND_UP?

Yeah, pretty sure.
