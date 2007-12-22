Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbXLVJrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbXLVJrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 04:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbXLVJrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 04:47:16 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:56766 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbXLVJrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 04:47:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hKWRhs5yKCPQqaE6ps1/bkV3cTWfC4Du8VFMRG1sme0oYWEBuRX/L5JgMxO5YCqbN1ViOYWX23BZWn3V8rpOrg88x3V5ETULkBhYf3sDLuzKnsHqlrj9k26G8OmXHTnta3UZcQqgSApCG7rXFceSfgfl+MIvt0tzrVnzZp+/5OM=
Message-ID: <84144f020712220147q2e291fa1t4ee03e4d64be95b@mail.gmail.com>
Date: Sat, 22 Dec 2007 11:47:14 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>
Subject: Re: [PATCH] SC26XX: New serial driver for SC2681 uarts
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, "Andy Whitcroft" <apw@shadowen.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20071205092506.GA6691@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071202194346.36E3FDE4C4@solo.franken.de>
	 <20071203155317.772231f9.akpm@linux-foundation.org>
	 <20071204234112.GA12352@alpha.franken.de>
	 <20071204192738.54e79a97.akpm@linux-foundation.org>
	 <20071205092506.GA6691@alpha.franken.de>
X-Google-Sender-Auth: 2a0b04f06c6c25f0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Dec 5, 2007 11:25 AM, Thomas Bogendoerfer <tsbogend@alpha.franken.de> wrote:
> > These:
> >
> > > +#define READ_SC(p, r)        readb((p)->membase + RD_##r)
> > > +#define WRITE_SC(p, r, v)    writeb((v), (p)->membase + WR_##r)
> >
> > and these:
> >
> > > +#define READ_SC_PORT(p, r)     read_sc_port(p, RD_PORT_##r)
> > > +#define WRITE_SC_PORT(p, r, v) write_sc_port(p, WR_PORT_##r, v)
> >
> > really don't need to exist.  All they do is make the code harder to read.
>
> but they make the code safer. The chip has common register and port
> registers, which are randomly splattered over the address range. And
> some of them are read only, some write only. Read only and Write
> only register live at the same register offset and their function
> usually doesn't have anything in common. By using these macros I'll
> get compile errors when doing a READ_SC from a write only register
> and vice versa. I will also get compile errors, if I try to access a
> common register via READ_SC_PORT/WRITE_SC_PORT.

You can use grep to make sure there are no reads to a write-only
register. What you have there is not safety but macro obfuscation at
its best. It makes the code harder to read for anyone not intimately
familiar with the driver.
