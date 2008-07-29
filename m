Return-Path: <linux-kernel-owner+w=401wt.eu-S1759165AbYG2Rq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165AbYG2Rq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYG2Rqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:46:47 -0400
Received: from gw.goop.org ([64.81.55.164]:49698 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbYG2Rqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:46:46 -0400
Message-ID: <488F5781.2030909@goop.org>
Date: Tue, 29 Jul 2008 10:46:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, steiner@sgi.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Comments on UV tlb flushing
References: <488E644B.10801@goop.org> <200807291412.18495.nickpiggin@yahoo.com.au> <20080729133204.GA13138@sgi.com> <488F2C9B.9070306@goop.org> <20080729173420.GA18296@sgi.com>
In-Reply-To: <20080729173420.GA18296@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cliff Wickman wrote:
> I don't know much about x86 configuration options.  It looks like
> CONFIG_X86_GENERICARCH is fairly new, so I don't know where to look
> for samples of how it will be set by RH and SuSE.
>   

No, it's a very old option.  Certainly the Fedora Rawhide kernel I have 
sitting here has it set, and I'm pretty sure RHEL always has it set, 
since it's necessary to support the big iron hardware that people like 
to run RHEL on.  Basically, if a distro doesn't have it set, then they 
don't want to support big machines like yours and you should just 
recommend your customers use something else.  There are a lot of other 
config options which will affect whether a kernel is suitable for your 
hardware, like max cpus.  A "desktop only" distro might set max cpus to 
8 or 16, which I assume would be disappointingly small for someone who's 
just bought a 4k cpu machine.

> But if the tlb_uv.o code should be present in "every" distro x86 kernel
> I don't see the point of having to configure it in.  Why not just
> configure it out for small (embedded) kernels?

Because it's not an binary thing.  Lots of people who are compiling 
their own kernels for specialized uses don't set CONFIG_EMBEDDED, but 
also don't want a kitchen sink kernel.  6k isn't that much, but if every 
obscure platform enabled some always-on code it rapidly starts to build up.

Basically, if you want to make sure if you're going to get some level of 
distro support, you need to make contact with the distros directly and 
talk about what you'd like them to do.

    J
