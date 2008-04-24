Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbYDXJSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbYDXJSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 05:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYDXJSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 05:18:37 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:21013 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbYDXJSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 05:18:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VMOCv/vF0Omssp3lk19CTb5vMrZtsMVCr5eP3b9buO/sIOijkcRpdBeZV24ryOAOOBzgAbWAw/eFWv3pWSXsrDMJUXX2320ru0fn8j3ho+F4/xGSQxMw/N5Z1eEU2OeyYumxCbS0nZtFJLBBr+FAHpSc3vLYXeBOb1Xaz5cWYpk=
Message-ID: <87a5b0800804240218l3e907acah438dded122cdec33@mail.gmail.com>
Date: Thu, 24 Apr 2008 10:18:34 +0100
From: "Will Newton" <will.newton@gmail.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [RFC] Introduce __ARCH_WANT_SYS_SYSFS
Cc: "Kyle McMartin" <kyle@mcmartin.ca>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
In-Reply-To: <8bd0f97a0804231059w76592878s3f6bf4a488b3ddea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com>
	 <87a5b0800804220816y72a7f4f9gec2111df08a1a57f@mail.gmail.com>
	 <20080422152426.GG19802@phobos.i.cabal.ca>
	 <87a5b0800804220834q4d6daec1x4146d211115ab5c@mail.gmail.com>
	 <20080422153849.GH19802@phobos.i.cabal.ca>
	 <87a5b0800804230736k340e7fe9mffbd72b5b8164015@mail.gmail.com>
	 <20080423154038.GL19802@phobos.i.cabal.ca>
	 <87a5b0800804230850y4d577ff2taf1689f4af26b274@mail.gmail.com>
	 <8bd0f97a0804230905x19fd96aevc8f225d241e59369@mail.gmail.com>
	 <8bd0f97a0804231059w76592878s3f6bf4a488b3ddea@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 6:59 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
>
> On Wed, Apr 23, 2008 at 12:05 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
>  > On Wed, Apr 23, 2008 at 11:50 AM, Will Newton <will.newton@gmail.com> wrote:
>  >  > On Wed, Apr 23, 2008 at 4:40 PM, Kyle McMartin <kyle@mcmartin.ca> wrote:
>  >  >  > On Wed, Apr 23, 2008 at 03:36:23PM +0100, Will Newton wrote:
>  >  >  >  > +config ARCH_HAS_SYS_SYSFS
>  >  >  >  > +     bool
>  >  >  >  > +     default y
>  >  >  >  > +
>  >  >  >  >  source "init/Kconfig"
>  >  >  >  >
>  >  >  >
>  >  >  >  Sorry, I meant something more like
>  >  >  >
>  >  >  >
>  >  >  >  config ARCH_HAS_SYS_SYSFS
>  >  >  >         def_bool !BLACKFIN
>  >  >  >         help
>  >  >  >           Obsolete sys_sysfs syscall
>  >  >  >
>  >  >  >  in init/Kconfig
>  >  >  >
>  >  >  >  But, it's your patch, you can do it however you like. :)
>  >  >
>  >  >  That's definitely shorter - but it feels a bit more like #ifdef
>  >  >  CONFIG_BLACKFIN which is explicitly what I don't want to do, because
>  >  >  I'm not actually interested in blackfin. ;-)
>  >
>  >  i'd have to agree that updating asm/unistd.h fits better with existing
>  >  paradigm.  if we want to talk about converting *all cases* to Kconfig,
>  >  we can do it in a separate thread.  splitting the design between two
>  >  different files is simply confusing to everyone involved as they spend
>  >  their time going "well which way am *i* supposed to do it".
>
>  thinking about this some more ... we actually have three choices here,
>  not just two.  checksyscalls.sh introduced a new form in asm/unistd.h:
>  #define __IGNORE_sysfs
>  perhaps we should be unifying the __ARCH_WANT_XXX and the __IGNORE_XXX

I'm not sure this would be possible. IGNORE is saying "please don't
warn me about the fact that I don't define define this syscall".
ARCH_WANT is saying "give me the generic implementation of this
syscall". You should never define IGNORE and ARCH_WANT for the same
syscall, but you may want to have neither - you have defined the
syscall but you don't want the generic version.

>  -mike
>
