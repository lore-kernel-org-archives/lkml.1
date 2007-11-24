Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbXKXOZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbXKXOZF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 09:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbXKXOY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 09:24:56 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:47523 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752820AbXKXOYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 09:24:55 -0500
Date: Sat, 24 Nov 2007 14:34:41 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, kune@deine-taler.de,
       johannes@sipsolutions.net
Subject: Re: [RFC] Documentation about unaligned memory access
Message-ID: <20071124143441.41657307@poseidon.drzeus.cx>
In-Reply-To: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2007 00:15:53 +0000 (GMT)
Daniel Drake <dsd@gentoo.org> wrote:

> Being spoilt by the luxuries of i386/x86_64 I've never really had a good
> grasp on unaligned memory access problems on other architectures and decided
> it was time to figure it out. As a result I've written this documentation
> which I plan to submit for inclusion as
> Documentation/unaligned_memory_access.txt
> 
> Before I do so, any comments on the following?
> 

A very nice, and much needed document. I think you should include one thing though:

memcpy() is _only_ safe when one of the pointers is char* or void*. If it is anything more complex than that, gcc will assume alignment and optimise based on that. E.g. memcpy() of two long:s generates the same assembly as doing an assignment.

(Technically it is no different for char* and void*, but since they have byte alignment, gcc can't really do anything creative.)

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
