Return-Path: <linux-kernel-owner+w=401wt.eu-S1762852AbYBNSSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762852AbYBNSSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbYBNSSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:18:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:36750 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbYBNSSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:18:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=MlFY+RnM/Osp8dnrWqfb/19oaTwCBjsZCTM8x612p5yAhS0pbYL/3yNDHSDzqs8fGC3Wz7OljpArn8F9woAr5FcoZ2OX3Dt+ybYP+fyPKUFowM6YoF+S52EN1XuWhCTYhR1XPk8faIlUGnDQuOXErMhWKF+UkJWGk227WFCY2Z8=
Message-ID: <84144f020802141018i235d3adfu13a84d124dc3964e@mail.gmail.com>
Date: Thu, 14 Feb 2008 20:18:02 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nishanth Aravamudan" <nacc@us.ibm.com>
Subject: Re: [PATCH 2/6] fs/direct-io.c: Use DIV_ROUND_UP
Cc: "Julia Lawall" <julia@diku.dk>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <20080214173850.GC14191@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.58.0802141614050.1185@pc-041.diku.dk>
	 <20080214173850.GC14191@us.ibm.com>
X-Google-Sender-Auth: 845e7e6c93ad4b2c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishanth,

On Thu, Feb 14, 2008 at 7:38 PM, Nishanth Aravamudan <nacc@us.ibm.com> wrote:
>  Is it just me, or does
>
>         ((user_addr + iov[seg].iov_len + PAGE_SIZE - 1)/PAGE_SIZE - user_addr/PAGE_SIZE)
>
>  not simplify to
>
>         = ((iov[seg].iov_len + PAGE_SIZE - 1)/PAGE_SIZE + user_addr/PAGE_SIZE - user_addr/PAGE_SIZE)
>
>         = ((iov[seg].iov_len + PAGE_SIZE - 1)/PAGE_SIZE)
>
>         = DIV_ROUND_UP(iov[seg].iov_len, PAGE_SIZE)
>
>  CMIIW.

I double-checked this and I believe you're correct. It's simpler to
see when you do:

  x = user_addr
  y = iov[seg].iov_len
  z = PAGE_SIZE

So

  (x + y + z - 1)/z - x/z

  = [x + (y + z - 1)]/z - x/z

  = [xz + z(y + z - 1)]/z^2 - x/z

  = x/z + (y + z - 1)/z - x/z

And the rest follows from your simplifications.

                                      Pekka
