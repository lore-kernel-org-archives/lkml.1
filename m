Return-Path: <linux-kernel-owner+w=401wt.eu-S1763076AbYDXQEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763076AbYDXQEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756780AbYDXQD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:03:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:26677 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760186AbYDXQDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:03:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=vHamRtQYd+GYGfQDC+KPnyEsLkdkwjlGa1zUtkx9RzYuAXi+KWdQKYWhqbjCPNgT+a0CGSr6rBQaMeUKTYuiLa1LXO5nlrLphTLxmWu8mR5kYagpCYObDk4i6T7R9mx0ud+wvQaWlKwgiJ6NWbuSjT9VicF800CpTjMGwts2T78=
Message-ID: <517f3f820804240903y788102bar5c7d1fa9bcee1c8a@mail.gmail.com>
Date: Thu, 24 Apr 2008 18:03:53 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH] alternative to sys_indirect, part 1
Cc: torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       drepper@redhat.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20080424.083908.147395158.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>
	 <20080424112514.055d8071@the-village.bc.nu>
	 <alpine.LFD.1.10.0804240828100.2779@woody.linux-foundation.org>
	 <20080424.083908.147395158.davem@davemloft.net>
X-Google-Sender-Auth: c870c6a70eeb999b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/08, David Miller <davem@davemloft.net> wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
>  Date: Thu, 24 Apr 2008 08:29:14 -0700 (PDT)
>
>
>  >
>  >
>  > On Thu, 24 Apr 2008, Alan Cox wrote:
>  > >
>  > > Given we will never have 2^32 socket types, and in a sense this is part
>  > > of the type why not just use
>  > >
>  > >     socket(PF_INET, SOCK_STREAM|SOCK_CLOEXEC, ...)
>  >
>  > Ok, I have to admit that I find this very appealing. It looks much
>  > cleaner, but perhaps more importantly, it also looks both readable _and_
>  > easier to use for the user-space programmer.
>
>
> Me too.

But this approach fixes just one of the interfaces.  There are 7 or 8
other interfaces that need to solve the same problem.  What about
those?

It strikes me to be cleanest to use the same solution for all of them
-- i.e., new syscalls (seems simplest) or sys_indirect() -- including
socket().

-- 
I'll likely only see replies if they are CCed to mtk.manpages at gmail dot com
