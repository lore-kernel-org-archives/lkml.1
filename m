Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbXEJMLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbXEJMLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXEJMLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:11:23 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:9238 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbXEJMLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:11:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BC6VVEO7bYxNzKvQsvjy4gep3UK1FwUfb653kquFNgcOAmE0B83Rju7aAplrsB8BD8cybCAfidcYuPwuP9sl9J2+Ih4ECLFAaqBmeiL34BM//jrQzwGMXGdHEMHGC1XwtjOk/ff2a+ayKTzshrMy71oICObdZuVgS2kVj1recKM=
Message-ID: <a781481a0705100511l1bfdc7f3tc2669eb916f76594@mail.gmail.com>
Date: Thu, 10 May 2007 17:41:21 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: [PATCH] net: trivial MLX4_DEBUG dependency fix.
Cc: "Paul Mundt" <lethal@linux-sh.org>, "Roland Dreier" <rolandd@cisco.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <aday7jw29ci.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070510035028.GA26453@linux-sh.org> <aday7jw29ci.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 5/10/07, Roland Dreier <rdreier@cisco.com> wrote:
>  > CONFIG_MLX4_DEBUG works out to a def_bool y for those that
>  > have CONFIG_EMBEDDED set. Make it depend on MLX4_CORE..
>
> Thanks, applied...  (by the way, this bug just results in an
> extraneous CONFIG variable being defined, right?  There's no further
> breakage -- or am I misunderstanding the situation?)

Yeah, it won't cause any build breakage. It doesn't cause anything to
even get _built_ actually, because of the way this config option is
used directly in the .h and .c sources in drivers/net/mlx4/ (which is
itself compiled only when MLX4_CORE=y or m), and not in a Makefile.

>  > I'll let someone else wonder why debugging output is default enabled,
>  > this seems to be a worrying trend as of late.
>
> Actually this option just controls whether to build the debugging
> output at all.  The output is controlled at runtime with a module
> parameter (which can be changed via sysfs after the module is loaded),
> and the output defaults to off.
>
> The reason why I want building the debugging stuff to default to y is
> so that distros automatically build modules with debugging enabled.
> Otherwise it's a pain to try and gather info from someone who has
> problems with a kernel they didn't build.

IMHO default configs must be aimed at production usage scenarios, so
are better off without debugging enabled by default. Except if the
driver is really new / EXPERIMENTAL where the goal is to get it tested
out by all users asap (and no production systems would be using it
anyway).

Just my 2 paise,
Satyam
