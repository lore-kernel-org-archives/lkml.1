Return-Path: <linux-kernel-owner+w=401wt.eu-S932976AbYB2PrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976AbYB2PrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 10:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758170AbYB2PrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 10:47:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:32509 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbYB2PrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 10:47:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=NlUp/c8XcdAQ3vaV8zjh1R5YicxGy9h8KWi8AcvwhUGi1JaEauc6cTiR292WKPlR2NdBvLutmczbg8n367iwwjVK5/4v2XJ9K9jTfcTeMD0Y+IyfsffA+7KUqFqPYhGwv38h7OGOERv1Rd5YqVp6EHK3ufL3P5Tjlwtip0kpIjk=
Message-ID: <74d8fc520802290747o2c97992ar7af2b8c295fe2fb2@mail.gmail.com>
Date: Fri, 29 Feb 2008 15:47:08 +0000
From: "Gordon Mckeown" <ml_lkml@thefluffyone.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Very high IOWait during all disk activity
Cc: "Tomasz Chmielewski" <mangoo@wpkg.org>
In-Reply-To: <47C82244.60307@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47C82244.60307@wpkg.org>
X-Google-Sender-Auth: 8697a231fa31572a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 3:18 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>  Unless you can write to the disk faster than fetch data from /dev/zero -
>  yes, it is normal.

OK, thank you; it has been a struggle to get confirmation of this;
perhaps because the way IOWait is measured has changed at some point?

>  Try running:
>
>    cat /dev/zero | bzip2 -c >/dev/null
>
>  when your IOwait is big (because you write a big file), and then watch
>  the numbers.

Ah, I can see that the CPU-intensive command soaks up the cycles that
would otherwise have been reported as IOWaits.

Unfortunately this doesn't help explain why Windows XP on the same box
can complete an "identical" copy operation in half the time. Perhaps
it's just due to the different filesystems, or the way write caching
works?

Thanks,

Gordon.
