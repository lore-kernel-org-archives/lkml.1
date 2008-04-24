Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbYDXQHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbYDXQHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763386AbYDXQHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:07:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:36703 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760103AbYDXQG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:06:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=js4Amn1jpZbrXS8LLthZd1BYH5Zyzz2zFVnnPlWZ8U4U+qV4xA8zeXBcaO+HYOxF19CZzPgbkjmMINvAEUXVhKhuA5ckLOudSmCPAiadHLSJnvj+ui1Wjjf/9XLno6Yi7N2tFwFOnHppt1xXSRvSh+iaMN6ZOTOpNw/dCW2qQN4=
Message-ID: <517f3f820804240906k6a701c2et86a4cabd730a8651@mail.gmail.com>
Date: Thu, 24 Apr 2008 18:06:55 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] alternative to sys_indirect, part 1
Cc: "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <20080424160352.30f2dd5b@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>
	 <20080424112514.055d8071@the-village.bc.nu>
	 <481096C3.2020206@redhat.com>
	 <20080424152436.6cf53c1b@the-village.bc.nu>
	 <4810A46B.1090809@redhat.com>
	 <20080424160352.30f2dd5b@the-village.bc.nu>
X-Google-Sender-Auth: d2e26a3e6f2475ed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/08, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > You didn't read what I wrote.
>
>
> The feeling is mutual
>
>
>  > For those the implementer must ensure that during the development no
>  > value is used which can conflict with any current and future assigned
>  > value and not with any other development.
>
>
> Kernel socket type values are assigned by the kernel team so that
>  isn't a problem.
>
>
>  > > Every other property of a socket via accept() is inherited from the
>  > > parent. Making one property different would be bizarre and ugly.
>  >
>  > Implementing this would visibly change existing code and it would
>  > actively violate POSIX.  Not a good idea.
>
>
> POSIX has no interface for this new behaviour you propose so that is
>  complete crap. The moment you use one of these features you stepped
>  outside of the POSIX spec - and you know that. If there was an existing
>  standard we wouldn't have a problem.

Alan, I agree with your analysis of the standard on that last para,
but I'm still not convinced that having the behavior inherited from
accept() would be good.  The problem (IIUC) is that after the
accept(), a userland programmer might want to immediately change the
O_CLOEXEC for the descriptor, and there would be the same race there
that this whole thread is about avoiding.

-- 
I'll likely only see replies if they are CCed to mtk.manpages at gmail dot com
