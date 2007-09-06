Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbXIFK4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbXIFK4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 06:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbXIFKz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 06:55:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:22464 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbXIFKz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 06:55:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Xn1I11WvoGIYXFrfCtg5js2MzWlyQNDmwV/PaqiumwHXhd0nA6r78hrYTwD6YXfEgJfG/VhgZ1wzpo2S5yix1Stzo54/0BmoSng+Lu0ClqtslaM1HbxFjuWWh9/1Ef966r8TtQjVqW3N/31Z07/aBTdlNrqsMRKGLaa4r6NA1MI=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [PATCH 0/3] build system: section garbage collection for vmlinux
Date: Thu, 6 Sep 2007 11:55:46 +0100
User-Agent: KMail/1.9.1
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
References: <200709051443.21522.vda.linux@googlemail.com> <200709051946.12096.vda.linux@googlemail.com> <20070905203438.GG475@flower.upol.cz>
In-Reply-To: <20070905203438.GG475@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709061155.46667.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2007 21:34, Oleg Verych wrote:
> > > > Build system: section garbage collection for vmlinux
> > > 
> > > Maybe this is just a test suit to get finish with `make XYZ static`?
> > 
> > They are vaguely connected in a sense that unused function which is
> > not marked static doesn't generate gcc warning, but will be discarded
> > by --gc-sections. "make XYZ static" also tends to find them - you make
> > function static, you recompile the file, and gcc informs you that
> > the function is not used at all!
> > 
> > This happened to me when I did aic7xxx patches.
> > 
> > You may yse --print-gc-sections to see the list of discarded sections.
> 
> Anyway, this is gccism/binutilizm. That about other possible/future
> options?
> 
> Give me example, please, why function must be non static if not used.

Where do you see I'm saying that they must be non-static?
I'm all for marking functions static. I just did it for aic7xxx.

> If usage requires kconfig tuning, then this is a better way to go,

We already do it, but we don't have enough developers to audit
every driver for every possible combination of config options.
As a result, there always be some amount of unused functions and data.
Using --gc-sections will discard that.

> than to adopt yet another GNU/Luxury.

Actually, this is how linkers should have worked long ago.
Borland's Turbo Pascal was doing it ten+ years ago.

I don't understand why you are opposed to toolchain helping
humans to get optimized result. But it's fine with me.
I won't force anyone to select CONFIG_DISCARD_UNUSED_SECTIONS.
--
vda
