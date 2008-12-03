Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbYLCWwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbYLCWwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 17:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbYLCWwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 17:52:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:3570 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbYLCWwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 17:52:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tQRnjeMBpNfnIdamMmEdLabMnGWTJfCzypl2mduJfCWdJ87lim4ALwbw8TJcNzvajW
         Sx8S9qcjoTEnhyjrWZWwLFZvkrSu85GISjyINoJFOlpKIb5mC2A56Yb54Xfss7ZXsCrR
         3Kzop/4nsNmIfR4rxJvjDALXvLmExKXirIJUY=
Date: Thu, 4 Dec 2008 01:56:47 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixup MODULE_DEVICE_TABLE(dmi, ...)
Message-ID: <20081203225647.GA13847@x200.localdomain>
References: <20081114234131.GA28559@x200.localdomain> <1226747692.3687.285.camel@macbook.infradead.org> <20081121015559.GA4478@x200.localdomain> <20081203004120.460166ac.akpm@linux-foundation.org> <1228295002.27314.6.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228295002.27314.6.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 09:03:21AM +0000, David Woodhouse wrote:
> On Wed, 2008-12-03 at 00:41 -0800, Andrew Morton wrote:
> > The changelog is too crappy for me.  Why did that error occur, and how
> > does the patch fix it?
> 
> Well, you repeated the explanation of what's wrong -- although I don't
> see how it actually causes an _error_; it works here.

It's just gcc version,

	gcc version 3.4.6 (Gentoo 3.4.6-r2 p1.5)

which is 5-10% faster than 4.1.2, that's why I switched back to it.

> The problem is that the MODULE_DEVICE_TABLE(dmi, foo) line expands to...
> 
> extern const struct dmi_device_id __mod_dmi_device_table
>       __attribute__ ((unused, alias("foo")));
> 
> And 'struct dmi_device_id' doesn't exist -- what we have is 'struct
> dmi_system_id'.
> 
> In practice, this doesn't seem to matter because we never ask the
> compiler to look _inside_ that struct -- it's just like a forward
> declaration of 'struct foo' and then using pointers to it.
> 
> But it looks like Alexey's managed to find a way to actually make a
> compiler barf on it, so that increases the motivation to fix it
> promptly...
