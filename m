Return-Path: <linux-kernel-owner+w=401wt.eu-S932069AbXCHRYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbXCHRYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:24:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932074AbXCHRYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:24:06 -0500
Received: from mail.suse.de ([195.135.220.2]:38494 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069AbXCHRYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:24:03 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Dave Jiang <djiang@mvista.com>
Subject: Re: [PATCH] x86_64 RESTORE_CONTEXT missing '\n'
Date: Thu, 8 Mar 2007 18:14:52 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, trini@kernel.crashing.org,
       sshtylyov@ru.mvista.com
References: <20070307204516.GA24095@blade.az.mvista.com>
In-Reply-To: <20070307204516.GA24095@blade.az.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703081814.53153.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 March 2007 21:45, Dave Jiang wrote:
> 
> The RESTORE_CONTEXT macro is missing the '\n' at the end. It was removed in the
> previous patch that touched system.h. It causes compile failure if any
> inline asm is added after the macro. Discovered this when playing with
> kgdb.

We went through this several times. kgdb has no business to poke 
into kernel private macros like this and it shouldn't do that. 
So fixing kgdb to not require touching the context switch is the right
change.

-Andi
