Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbYFJTi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbYFJTi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYFJTiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:38:20 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62850 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753710AbYFJTiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:38:20 -0400
Date: Tue, 10 Jun 2008 20:36:54 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Glauber Costa <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: Re: [PATCH 11/15] x86: move enabling of io_apic to prepare_cpus
In-Reply-To: <86802c440806101209q301bcef0ia859db7e587bd42e@mail.gmail.com>
Message-ID: <Pine.LNX.4.55.0806102025460.1702@cliff.in.clinika.pl>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com> 
 <Pine.LNX.4.55.0806091620250.26593@cliff.in.clinika.pl>  <484D8813.4040807@redhat.com>
  <Pine.LNX.4.55.0806092058550.26593@cliff.in.clinika.pl> 
 <86802c440806091353m240ab7adocbaf5dacd15504f7@mail.gmail.com> 
 <Pine.LNX.4.55.0806092159350.26593@cliff.in.clinika.pl> 
 <Pine.LNX.4.55.0806100341520.31588@cliff.in.clinika.pl> 
 <86802c440806092208s338cf6b6q892f5149bbd142ca@mail.gmail.com> 
 <484E7B03.8000604@redhat.com>  <Pine.LNX.4.55.0806101418510.1702@cliff.in.clinika.pl>
 <86802c440806101209q301bcef0ia859db7e587bd42e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008, Yinghai Lu wrote:

> kernel should not assume io apic register is set right by firmware.

 What is the basis of this assumption?  Linux generally assumes the
chipset components have been placed by the firmware into a consistent
state.  That does not necessarily mean suitable for Linux, hence the need
to reconfigure a bit here or there, but there should be no need to touch
components that are not going to be used by Linux directly.  The I/O APIC
is no different.

> and kernel actually doesn't trust them, and clear the io apic registers.

 The I/O APIC registers are cleared, because this is the only way you can
assure inconsistent configuration does not happen during reconfiguration.  
For example two inputs using the same vector or set up into the ExtINTA
mode.  The original intent of the code was not to paper over breakage in
the firmware.  You are trying to change it and it can be done, but it has
to be justified well.

> that patch just move that early before enable error vector.

 What I am saying repeatedly is clearing of the I/O APIC is not guaranteed
to happen for all the possible cases of Linux configuration.  Which means
this is a partial solution only -- please try to propose a better one or
provide the original problem report so that someone else can have a look
at it.  What's triggering the error interrupt for example?  Is it
recoverable?

  Maciej
