Return-Path: <linux-kernel-owner+w=401wt.eu-S965193AbXBTITe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965193AbXBTITe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 03:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965203AbXBTITe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 03:19:34 -0500
Received: from qb-out-0506.google.com ([72.14.204.225]:58071 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965193AbXBTITd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 03:19:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M2ZmbbH5W5/B+oDjsrLnReCWcyIBDiUC27U0x0c3qZlw8+W5y9m2/C9OhNXd+5qBCa2sJTkxKgcx3kqe+Pkw0Ne2kWNBMQRV7NyqHs10V28k3uBwYueA1LX2YinMrop5KQbn2UHZhP6GZiUNtmONgKqvBE4mJiL1frKPhqZ6yB8=
Message-ID: <38b2ab8a0702200019q22bbc1b6ma0ab2771e152c288@mail.gmail.com>
Date: Tue, 20 Feb 2007 09:19:31 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Avi Kivity" <avi@argo.co.il>
Subject: Re: memparse(), simple_strtoul() prototypes...
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <45D9AE8D.4060300@argo.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0702180804l26d99a01y558bce2ee964d973@mail.gmail.com>
	 <45D8EFB8.4050805@zytor.com>
	 <38b2ab8a0702190503n32caeab3j2c2139c71cb5a9c5@mail.gmail.com>
	 <45D9AE8D.4060300@argo.co.il>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/19/07, Avi Kivity <avi@argo.co.il> wrote:
> Francis Moreau wrote:
> >> > unsigned long simple_strtoul(const char *cp, char **endp,unsigned
> >> int base)
> >
> > hm, I don't get your point. I understand why we cast 'cp' into a (char
> > *) but that's not my point. My point is why aren't all function
> > parameters are not const ?
> >
>
> 'cp' can be passed as const, because simple_strtoul() does not modify
> it. 'endp' cannot be passed as const, because simple_strtoul() cannot
> know whether the caller would want to modify the string or not.
>
> Whichever way it is written, it is broken.  If changed to 'const', it
> would preclude the caller from modifying the string if one has a
> non-const string.  As written, it can silently convert a const string to
> a non-const string.  However, as written it is (a) standard conforming,
> and (b) more useful.
>

ok I think I finally got it and I agree that both ways are broken.

Maybe changing simple_strtoul() prototype as follow would be better ?

int simple_strtoul(const char *cp,  unsigned long *value, unsigned base)

the function would return the number of parsed char, and 'value' would
be the result.
-- 
Francis
