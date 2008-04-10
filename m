Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYDJDZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYDJDZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 23:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbYDJDYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 23:24:52 -0400
Received: from ozlabs.org ([203.10.76.45]:56912 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbYDJDYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 23:24:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 12/17] Immediate Values - Kconfig menu in EMBEDDED
Date: Thu, 10 Apr 2008 13:23:55 +1000
User-Agent: KMail/1.9.9
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Adrian Bunk <bunk@stusta.de>, Christoph Hellwig <hch@infradead.org>,
       akpm@osdl.org
References: <20080409150829.855195878@polymtl.ca> <20080409152050.721310907@polymtl.ca>
In-Reply-To: <20080409152050.721310907@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804101323.56697.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 April 2008 01:08:41 Mathieu Desnoyers wrote:
> +config IMMEDIATE
> +	default y if !DISABLE_IMMEDIATE

Wouldn't it be simlpler to roll DISABLE_IMMEDIATE into this?

ie.
	default y
	depends on HAVE_IMMEDIATE
	bool "Immediate value optimization" if EMBEDDED
	help
	  Immediate values are used as read-mostly variables that are rarely
	  updated. They use code patching to modify the values inscribed in the
	  instruction stream. It provides a way to save precious cache lines
	  that would otherwise have to be used by these variables.

	  It consumes slightly more memory and requires to modify the instruction
	  stream each time a variable is updated. Should really be disabled for
	  embedded systems with read-only text.

Cheers,
Rusty.
