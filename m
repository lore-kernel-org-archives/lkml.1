Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbYHPK4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbYHPK4J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 06:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbYHPKz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 06:55:57 -0400
Received: from ozlabs.org ([203.10.76.45]:58874 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbYHPKz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 06:55:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] BUILD_BUG_ON sucks
Date: Sat, 16 Aug 2008 20:55:44 +1000
User-Agent: KMail/1.9.9
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org
References: <20080816100948.GB19926@martell.zuzino.mipt.ru>
In-Reply-To: <20080816100948.GB19926@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808162055.45136.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 August 2008 20:09:48 Alexey Dobriyan wrote:
> BUILD_BUG_ON should have never existed -- BUG_ON could upgrade itself to
> compile-breaking version if compiler has enough information and this is
> what patch does.
>
> The only downside is that one can't write BUG_ON(1) anymore.

Interesting idea, but I've come to actually like the semantic explicitness of 
BUILD_BUG_ON.  There's a difference between "we should never get here" 
and "this should never exist".

But maybe I just like it because we have it.  At very least BUILD_BUG_ON 
should definitely compile-barf on a non-constant expr, and vice versa for 
BUG_ON().

Note that BUG_ON() is a hack caused by lack of attribute((cold)).  "if (x) 
BUG()" is clearer, and possible in the long run as people upgrade compilers.

Cheers,
Rusty.
