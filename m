Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbYGGPzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbYGGPzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 11:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbYGGPzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 11:55:24 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:60579 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbYGGPzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 11:55:23 -0400
Date: Mon, 7 Jul 2008 10:55:10 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Roland McGrath <roland@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/2] elf loader support for auxvec base platform string
Message-ID: <20080707155510.GE9594@localdomain>
References: <20080703234140.GC9594@localdomain>
 <18541.35978.437115.957054@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18541.35978.437115.957054@harpo.it.uu.se>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: 1A318026-4C3D-11DD-B3D1-CE28B26B55AE-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> Nathan Lynch writes:
>  > Some IBM POWER-based platforms have the ability to run in a
>  > mode which mostly appears to the OS as a different processor from the
>  > actual hardware.  For example, a Power6 system may appear to be a
>  > Power5+, which makes the AT_PLATFORM value "power5+".
>  > 
>  > However, some applications (virtual machines, optimized libraries) can
>  > benefit from knowledge of the underlying CPU model.  A new aux vector
>  > entry, AT_BASE_PLATFORM, will denote the actual hardware.  For
>  > example, on a Power6 system in Power5+ compatibility mode, AT_PLATFORM
>  > will be "power5+" and AT_BASE_PLATFORM will be "power6".
> 
> Why on earth would you ever want AT_PLATFORM to differ from AT_BASE_PLATFORM?
> In cases that matter you admit that AT_BASE_PLATFORM takes precedence,
> so why involve a fake lame not-quite-the-platform in the first place?
> 
> Workaround for buggy software?

My apologies, I did not explain the motivation well.

The idea is that while AT_PLATFORM indicates the instruction set
supported, AT_BASE_PLATFORM indicates the underlying
microarchitecture.  It's not a matter of buggy software, or of one
value taking precedence over the other.
