Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbZBGXPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbZBGXPd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 18:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZBGXPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 18:15:24 -0500
Received: from outbound-mail-39.bluehost.com ([69.89.20.193]:34164 "HELO
	outbound-mail-39.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752389AbZBGXPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 18:15:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=n2yrsNnIyl51E/kGf5Gem4d2SzE9ZNxGck6nxmy//YGKqF2FGIPBOYpTUSRTA6FVupCLKGDG1lsjztnBjHyR0qIMPAQdMVrT1OtFgzYryaBB9emcczWRAIk31krerRc4;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [Bug #12608] 2.6.29-rc powerpc G5 Xorg legacy_mem regression
Date: Sat, 7 Feb 2009 15:15:20 -0800
User-Agent: KMail/1.9.10
Cc: Hugh Dickins <hugh@veritas.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <200902061445.11379.jbarnes@virtuousgeek.org> <1233975910.31963.56.camel@pasglop>
In-Reply-To: <1233975910.31963.56.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902071515.20560.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 6, 2009 7:05 pm Benjamin Herrenschmidt wrote:
> On Fri, 2009-02-06 at 14:45 -0800, Jesse Barnes wrote:
> > +    if (Base <= 1024*1024) {
> > +        /* Try legacy_mem (may not be available or implemented) */
> > +        if ((fd = linuxOpenLegacy(dev, "legacy_mem")) < 0) {
> > +            addr = mmap(NULL, Size, PROT_READ|PROT_WRITE, MAP_SHARED,
> > fd, Base); +            close(fd);
> > +            if (addr && addr != MAP_FAILED)
> > +                return addr;
> > +        }
> >      }
> > -    return addr;
> > +
> > +    /* Fall back to old method if legacy_mem fails or Base >= 1M */
> > +    return linuxMapPci(ScreenNum, Flags, dev, Base, Size,
> > PCIIOC_MMAP_IS_MEM); }
>
> I don't like the fallback if legacy_mem exists and returns an error,
> that's an indication that legacy memory is -not- available and thus
> whatever 'fallback' X will try (supposedly using /dev/mem) will be
> horribly broken and will probably end up scribbling all over system
> memory :-)

Yeah, but unless we fix all the callers (and possibly their callers), not 
falling back will keep X from starting...

-- 
Jesse Barnes, Intel Open Source Technology Center
