Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbXKSWWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbXKSWWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:22:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbXKSWV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:21:57 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:51601 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbXKSWV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:21:56 -0500
Date: Mon, 19 Nov 2007 23:21:51 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, rusty@rustcorp.com.au, ak@suse.de,
       chrisw@sous-sol.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 7/24] consolidate msr.h
Message-ID: <20071119222151.GA11178@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Glauber de Oliveira Costa <gcosta@redhat.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	glommer@gmail.com, tglx@linutronix.de, mingo@elte.hu,
	rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
	avi@qumranet.com, anthony@codemonkey.ws,
	virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
	kvm-devel@lists.sourceforge.net, zach@vmware.com,
	jun.nakajima@intel.com, Steven Rostedt <rostedt@goodmis.org>
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com> <11946337991750-git-send-email-gcosta@redhat.com> <11946338053158-git-send-email-gcosta@redhat.com> <11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com> <11946338212915-git-send-email-gcosta@redhat.com> <11946338263902-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <11946338263902-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 04:42:48PM -0200, Glauber de Oliveira Costa wrote:
> -	wrmsrl(MSR_CSTAR, ia32_cstar_target);
> +	wrmsrl(MSR_CSTAR, (u64)ia32_cstar_target);

Hmm, why do you add explicit casts? The compiler should convert that
correctly on its own.

> +static inline void wrmsrl(unsigned int msr, unsigned long long val)

Hmm, long long is 64 bit on all x86, but why not use explicit u64 to
show that?

Bastian

-- 
Captain's Log, star date 21:34.5...
