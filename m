Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbYBJRLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbYBJRLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 12:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYBJRLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 12:11:08 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:50442 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYBJRLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 12:11:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=C0MKrWD7oFFkqQlnnSR1XDUuhZ/qvgD0tdnCcNPxA8jr5fGgdcqUktaLsYPrb0QtzkBuJ6BSKun4Fv8N58RyX3942W7M5JPZOuNjbs44D5dZidfArp14EOFE3/5g9vbCsIoZYpecA3s5qzijkpHvRKYZoKJvPDVjmb1+S/Uqhts=
Message-ID: <84144f020802100911u7c1a3d3cm212c08d1bb3225d6@mail.gmail.com>
Date: Sun, 10 Feb 2008 19:11:05 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [stable] [PATCH] kernel 2.6.24.1 still vulnerable to the vmsplice local root exploit
Cc: "Oliver Pinter" <oliver.pntr@gmail.com>,
       "Bastian Blank" <bastian@waldi.eu.org>, "Niki Denev" <ndenev@gmail.com>,
       "Willy Tarreau" <w@1wt.eu>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, stable@kernel.org
In-Reply-To: <20080210170544.GA25353@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2e77fc10802092204t7764ff12s65304f70500e2090@mail.gmail.com>
	 <20080210063247.GQ8953@1wt.eu>
	 <2e77fc10802092238k13efb111ifcd298daaf7b4aba@mail.gmail.com>
	 <2e77fc10802100140q5c8adfb4k7db88d48cbd5f8b2@mail.gmail.com>
	 <20080210122250.GA24048@wavehammer.waldi.eu.org>
	 <2e77fc10802100439u18e89008j9181f3b445daa231@mail.gmail.com>
	 <20080210124731.GA25396@wavehammer.waldi.eu.org>
	 <6101e8c40802100502g6c3c2d01ufce1ce23c7c20c5a@mail.gmail.com>
	 <20080210170544.GA25353@kroah.com>
X-Google-Sender-Auth: fd4a556b0b74ede6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008 7:05 PM, Greg KH <greg@kroah.com> wrote:
> No, this is a different CVE, as it is a different problem from the
> original 09 and 10 report.
>
> It has been given CVE-2008-0600 to address this issue (09 and 10 only
> affect .23 and .24 kernels, and have been fixed.)
>
> > +             if(!access_ok(VERIFY_READ, base, len)) {
> > +                     error = -EFAULT;
> > +                     break;
> > +             }
>
> Hm, perhaps we should just properly check the len field instead?  That's
> what is being overflowed here...

Sorry, I forgot to cc you on this one:

http://lkml.org/lkml/2008/2/10/153

I don't see where the current code is checking that base is
accessible. We just check that we can copy the struct iovecs, right?

                        Pekka
