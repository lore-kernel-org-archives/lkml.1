Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZCDONS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZCDONS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 09:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbZCDOMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 09:12:52 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:31948 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbZCDOMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 09:12:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s9xapC/N7AN+WxgrIg5+B5B+tQ2kyydO7oZ8NkK2pEuRPBuMdLntGNIzRYBdkAy5Rk
         v8jEK1ZXVcbDUT4kZcLYygcAS9dU/f3aNiJCfwpDKE2fegl25+q9Dw93YKJDTKqMLPBS
         DrPtXFylv/WEE1ZjYIG0hKMvF5fsCcVuaaBKU=
Date: Wed, 4 Mar 2009 23:12:40 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [PATCH] generic debug pagealloc
Message-ID: <20090304141238.GA7168@localhost.localdomain>
References: <20090303160103.GB5812@localhost.localdomain> <20090303160503.GA6538@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20090303160503.GA6538@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 05:05:03PM +0100, Ingo Molnar wrote:
> if every architecture supports it now then i guess this config 
> switch can go away:
> 
> > +config ARCH_SUPPORTS_DEBUG_PAGEALLOC
> > +	def_bool y

The generic debug pagealloc needs the poison flag for each struct page.

So I introduced CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC for x86, powerpc,
sparc (64bit), and s390. If there is no CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC,
make config prompts the generic debug pagealloc in mm/Kconfig.debug for the
other architectures.

I was trying to add cleaner config dependency but
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC is my solution for now.
