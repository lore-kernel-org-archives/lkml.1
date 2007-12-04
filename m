Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbXLDQzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbXLDQzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXLDQyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:54:55 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:4551 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbXLDQyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:54:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WZ469d8EVh8uk/GFtQtN1I6T61LHZiqGd87vmiZ7iypfAn9SQx5K7b7d8KupbrQEHUCY6jAbVuJxOgb50CiIHgM380rOfK6KliXl7S3+yXsPd+VrW3Oe0fC/mqY4vdjpTezFHELTp/92PET+vCE0H2TGyao7Qb01MgUgxzDXsIQ=
Message-ID: <2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com>
Date: Tue, 4 Dec 2007 08:54:52 -0800
From: "Ray Lee" <ray@madrabbit.org>
To: "Adrian Bunk" <bunk@kernel.org>, "Matt Mackall" <mpm@selenic.com>
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Cc: "Marc Haber" <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20071204161811.GB15974@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071204114125.GA17310@torres.zugschlus.de>
	 <20071204161811.GB15974@stusta.de>
X-Google-Sender-Auth: e3ae307d14f934e8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Why hasn't anyone been cc:ing Matt on this?)

On Dec 4, 2007 8:18 AM, Adrian Bunk <bunk@kernel.org> wrote:
> On Tue, Dec 04, 2007 at 12:41:25PM +0100, Marc Haber wrote:
>
> > While debugging Exim4's GnuTLS interface, I recently found out that
> > reading from /dev/urandom depletes entropy as much as reading from
> > /dev/random would. This has somehow surprised me since I have always
> > believed that /dev/urandom has lower quality entropy than /dev/random,
> > but lots of it.
>
> man 4 random
>
> > This also means that I can "sabotage" applications reading from
> > /dev/random just by continuously reading from /dev/urandom, even not
> > meaning to do any harm.
> >
> > Before I file a bug on bugzilla,
> >...
>
> The bug would be closed as invalid.
>
> No matter what you consider as being better, changing a 12 years old and
> widely used userspace interface like /dev/urandom is simply not an
> option.

You seem to be confused. He's not talking about changing any userspace
interface, merely how the /dev/urandom data is generated.

For Matt's benefit, part of the original posting:

> Before I file a bug on bugzilla, can I ask why /dev/urandom wasn't
> implemented as a PRNG which is periodically (say, every 1024 bytes or
> even more) seeded from /dev/random? That way, /dev/random has a much
> higher chance of holding enough entropy for applications that really
> need "good" entropy.

A PRNG is clearly unacceptable. But roughly restated, why not have
/dev/urandom supply merely cryptographically strong random numbers,
rather than a mix between the 'true' random of /dev/random down to the
cryptographically strong stream it'll provide when /dev/random is
tapped? In principle, this'd leave more entropy available for
applications that really need it, especially on platforms that don't
generate a lot of entropy in the first place (servers).

Ray
