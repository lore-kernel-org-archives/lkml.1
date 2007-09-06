Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbXIFMeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbXIFMeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755631AbXIFMeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:34:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:27642 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbXIFMeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:34:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=pJloJ/nNbMie8GcfGtwo2jCs12cp76xZmNeStIYvtrCSJjuywQyBeTyUSWxr1/LdQ3Ym4WuWZABYfmjBngkatJXWF5VPv+q2jDIAUtd54n6ohXJeFrErggak1dBbfW3pwJ3jsLL7iesTDYecDTswR2pewQMlzcffxB3ZmKFXqy4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [PATCH 0/3] build system: section garbage collection for vmlinux
Date: Thu, 6 Sep 2007 13:33:47 +0100
User-Agent: KMail/1.9.1
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
References: <200709051443.21522.vda.linux@googlemail.com> <200709061155.46667.vda.linux@googlemail.com> <20070906114044.GM475@flower.upol.cz>
In-Reply-To: <20070906114044.GM475@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709061333.48084.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 September 2007 12:40, Oleg Verych wrote:
> On Thu, Sep 06, 2007 at 11:55:46AM +0100, Denys Vlasenko wrote:
> > We already do it, but we don't have enough developers to audit
> > every driver for every possible combination of config options.
> > As a result, there always be some amount of unused functions and data.
> > Using --gc-sections will discard that.
> 
> You've did a tool. Documenting this tool to have it available for
> testers/janitors/maintainers is a better way, than to have all that
> opinions/problems with merging-to-mainline.
> 
> > > than to adopt yet another GNU/Luxury.
> > 
> > Actually, this is how linkers should have worked long ago.
> > Borland's Turbo Pascal was doing it ten+ years ago.
> > 
> > I don't understand why you are opposed to toolchain helping
> > humans to get optimized result. But it's fine with me.
> > I won't force anyone to select CONFIG_DISCARD_UNUSED_SECTIONS.
> 
> That's why. It's treating symptoms, isn't it?

If I understand you correctly, you seem to think that this work
of identifying every piece of code which can end up unused under
specific combination of CONFIGs, and #ifdef'ing it out,
should be done by people, not machines.

I disagree.

Allyesconfig kernel has ~1700 unused functions/data objects,
and it is only *one* of possible .configs.
There is more than 2900 CONFIG options in kernel, giving you
about 3^2000 possible permutations.

If you find it interesting to work on making them
to not have unused functions, more power to you,
and good luck convincing people to accept tons
of additional #ifdefs.
--
vda
