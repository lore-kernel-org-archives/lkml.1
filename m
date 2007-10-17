Return-Path: <linux-kernel-owner+w=401wt.eu-S934449AbXJQUTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934449AbXJQUTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759003AbXJQUTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:19:45 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:13627 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662AbXJQUTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q9lrH6a7DFsXV8tYHTJxxkNduB79KX7AqFBY8J1o9runznhNhtspaccMFJ6daJy+WvPVCbYhbvtFVhoU7yps0X/UHbebtaVGsDQ6F+xli0mtnC6qnAvEM4YJSrYgk2/uOgKjtrpVzDEiqxKya+tode4Ao5o9ExD+A1X/or5MZxU=
Message-ID: <b0943d9e0710171319n180f05f1ta391e972a6a7efe9@mail.gmail.com>
Date: Wed, 17 Oct 2007 21:19:39 +0100
From: "Catalin Marinas" <catalin.marinas@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: suspicious ALSA empty commit
Cc: "Jaroslav Kysela" <perex@perex.cz>, "David Miller" <davem@davemloft.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       krzysztof.h1@wp.pl
In-Reply-To: <alpine.LFD.0.999.0710171057090.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071016.155044.82377336.davem@davemloft.net>
	 <alpine.LFD.0.999.0710161624350.26902@woody.linux-foundation.org>
	 <Pine.LNX.4.61.0710170809580.11118@tm8103.perex-int.cz>
	 <alpine.LFD.0.999.0710170854280.26902@woody.linux-foundation.org>
	 <Pine.LNX.4.61.0710171928250.11118@tm8103.perex-int.cz>
	 <alpine.LFD.0.999.0710171057090.26902@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, 17 Oct 2007, Jaroslav Kysela wrote:
> > I'm using stg on top of git for merging and easy tree rebasing, but the
> > version might be old (I'll try upgrade at first):
>
> Ahh. That may explain it. stg may well be using the low-level git internal
> commands (which *do* allow you to create any kind of commits you want,
> including bogus empty ones).

StGIT indeed creates empty commits (don't think there is anything
wrong with that specific version). Even the most basic command, "stg
new", creates an empty commit which is than filled with changes via
"stg refresh". Pushing patches may result in empty commits if a patch
was merged upstream. Failing import also leaves an empty commit if the
patch doesn't apply cleanly (and there is a .stgit-failed.patch file
left).

The "stg series -e" shows the empty patches and "stg clean" removes
them but I wouldn't do this automatically as empty patches are allowed
in StGIT, though in general for a limited time. I'll try to add
warning/error to commands like "mail" or "export" to make the user
aware.

-- 
Catalin
