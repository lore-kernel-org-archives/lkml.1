Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZHTXYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZHTXYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 19:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbZHTXYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 19:24:19 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:38073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755517AbZHTXYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 19:24:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
X-Fcc: ~/Mail/linus
Cc: James.Bottomley@HansenPartnership.com (James Bottomley), deller@gmx.de,
       rusty@rustcorp.com.au, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, dave.anglin@nrc.ca
Subject: Re: kernel segv with 2.6.31-rc6 ?
In-Reply-To: John David Anglin's message of  Thursday, 20 August 2009 19:01:13 -0400 <20090820230114.36D3E4E7A@hiauly1.hia.nrc.ca>
References: <1250805049.4302.121.camel@mulgrave.site>
	<20090820230114.36D3E4E7A@hiauly1.hia.nrc.ca>
X-Windows: the art of incompetence.
Message-Id: <20090820232357.934474730F@magilla.sf.frob.com>
Date: Thu, 20 Aug 2009 16:23:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> At some time, GCC may start a new .text section at the beginning of
> each function.  We do this on hpux but not linux.  This will cause
> multiple .text sections to be present in an object and allow finer grained
> stub placement.

arch/parisc/Makefile:

	# Without this, "ld -r" results in .text sections that are too big
	# (> 0x40000) for branches to reach stubs.
	ifndef CONFIG_FUNCTION_TRACER
	  cflags-y	+= -ffunction-sections
	endif
