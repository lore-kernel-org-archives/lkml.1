Return-Path: <linux-kernel-owner+w=401wt.eu-S1758370AbYDUXLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370AbYDUXLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYDUXLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:11:31 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:2167 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbYDUXLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hs/5FNo65hf9ttuT1N0Ed81sYr8AG6wXbPYenu/3pR0c2LdNBPKkHwsKmDyFqBm6A3R/2nxafeCnUZK20p4akDbVhvWW9B/cmjO+IwH4atnjeQWdUuQrmANPmjsBuy+AQ113K8Iv58i+9OGk0rv1+vQwc32Q27UFbxQQtWuMUZw=
Message-ID: <c4e36d110804211611ke56cba9td23e5735f40a469@mail.gmail.com>
Date: Tue, 22 Apr 2008 01:11:27 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Cc: paulmck@linux.vnet.ibm.com, "David Miller" <davem@davemloft.net>,
       torvalds@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au
In-Reply-To: <480D1CF1.7010300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>
	 <200804211812.16994.rjw@sisk.pl>
	 <alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org>
	 <20080421.133940.52972455.davem@davemloft.net>
	 <480D04A2.5000006@gmail.com> <480D0E14.1040306@gmail.com>
	 <480D147C.90602@gmail.com> <20080421225452.GF9153@linux.vnet.ibm.com>
	 <480D1CF1.7010300@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/22, Jiri Slaby <jirislaby@gmail.com>:
> On 04/22/2008 12:54 AM, Paul E. McKenney wrote:
>
> > On Tue, Apr 22, 2008 at 12:26:04AM +0200, Jiri Slaby wrote:
> >
> > >
> > > > Having slub_debug enabled, tomorrow will be results, I guess...
> > > >
> > > Sorry, one more entry:
> > >
> > > 00000000000000f0 dentry.d_op (Zdenek, offset ? around 136)
> > >
> >
>
>  Zdenek's is at offset 184.
>
>
> >
> > > 00f0000000000000 dentry.d_hash.next (me, offset 24)
> > > ffff81f02003f16c dentry.d_name.name (me, offset 56)
> > >        memory ORed by 000000f000000000
> > > fffff0002004c1b0 file.f_mapping (me, offset 176)
> > >        memory hole, it was something like
> > >        (ffff81002004c1b0 & ~00000f0000000000) | 0000f00000000000?
> > > ffffffffffffffff dentry.d_hash.next (Rafael, offset ? around 24)
> > >        -1, ~0ULL
> > >
> >
> > Are these running with CONFIG_PREEMPT_RCU?  Grasping at straws, but
> > there are a couple of patches that need to move from -rt to mainline,
> > but mostly related to SELinux.  So if both PREEMPT_RCU and SELinux
> > were in use, we might be missing "rcu-various-fixups.patch" from:
> >
>
>  $ grep RCU .config
>  CONFIG_CLASSIC_RCU=y
>  # CONFIG_RCU_TORTURE_TEST is not set
>  $ grep SECU .config
>  # CONFIG_EXT4DEV_FS_SECURITY is not set
>  # CONFIG_SECURITY is not set
>  # CONFIG_SECURITY_FILE_CAPABILITIES is not set
>
>  I guess not.
>
>  BTW the corruption I mentioned earlier was char 'ð' and it's ('p' | 0xf0)
> in latin2. I think it was set_ðending_irq IIRC. Whatever, it won't help us.
>

I've kernel compiled with preemptible RCU & Security - but usually
using selinux=off as a kernel parameter

Zdenek
