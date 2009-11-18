Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbZKRPPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbZKRPPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 10:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbZKRPPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 10:15:48 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:43905 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbZKRPPr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 10:15:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=p1d0liQA4zb/yE4FPsOPY0MBsWgT3AWMUmUclY+0wpfPU0T1jE5gny/0WJgsqNFT4S
         CIQc0jSNQeS9qvNK6ugK/bYDnTMf91OKAClP1bPIjT7vi3ZFAe6n8KgpGOOGYtSquBZz
         8mOXFzvft8Rf5AQye/OU+HcNVLrt0shYRehPM=
MIME-Version: 1.0
In-Reply-To: <4B03F2BF.4000402@gmail.com>
References: <4B03F2BF.4000402@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 18 Nov 2009 10:15:32 -0500
Message-ID: <8bd0f97a0911180715g2ef29ad6u102fbad4dbc4010e@mail.gmail.com>
Subject: Re: [PATCH] USB: FIX bitfield istl_flip:1, make it unsigned.
To: Roel Kluin <roel.kluin@gmail.com>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 08:12, Roel Kluin wrote:
> istl_flip is a signed bitfield of one bit so it can be -1 or 0.
> However in drivers/usb/host/isp1362-hcd.c:1103:
>
> finish_iso_transfers(isp1362_hcd,
>        &isp1362_hcd->istl_queue[isp1362_hcd->istl_flip]);
>
> So if isp1362_hcd->istl_flip is set, the 2nd argument becomes
> &isp1362_hcd->istl_queue[-1], which is invalid.

makes sense to me (both changes).
Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
