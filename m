Return-Path: <linux-kernel-owner+w=401wt.eu-S1762679AbXJZMFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762679AbXJZMFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 08:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbXJZMFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 08:05:32 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:26300 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbXJZMFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 08:05:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=q05RXXtN24oAzk0E/aysnGKR92qVzJTJSXeynZnwENBqcBh7wUM1lNgKKGx11flKDWI5Qm4NgjBtUIUqsN17430Bs1BOd01DM/jVD7noEEp1WZHWEltSs1Y8XwLHhyENf9CZAyyAQaip9FSuOXzLAILfIJytucTwqPlHnIaTh88=
Message-ID: <84144f020710260505y7a6335dbpa201015910744cba@mail.gmail.com>
Date: Fri, 26 Oct 2007 15:05:31 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Matthew Wilcox" <willy@linux.intel.com>
In-Reply-To: <1193173966-3550-1-git-send-email-matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193173966-3550-1-git-send-email-matthew@wil.cx>
X-Google-Sender-Auth: d654524bb0bdff28
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/24/07, Matthew Wilcox <matthew@wil.cx> wrote:
> +static void sb_vprintf(struct stringbuf *sb, const char *format, va_list args)
> +{
> +       char *s;
> +       int size;
> +
> +       if (sb->alloc == -ENOMEM)
> +               return;
> +       if (sb->alloc == 0) {
> +               sb->s = kmalloc(INITIAL_SIZE, GFP_ATOMIC);

How about putting ->gfp_flags to struct stringbuf and initializing
that in sb_init() instead of hard-coding to GFP_ATOMIC here?

Btw, the "sb" abbrevation is already used for "superblock". Perhaps we
could use "str" for these?

                                             Pekka
