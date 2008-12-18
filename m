Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752869AbYLRTgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbYLRTgb (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 14:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYLRTgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 14:36:21 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:47825 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYLRTgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 14:36:20 -0500
Date: Thu, 18 Dec 2008 13:35:50 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Catalin Marinas <catalin.marinas@arm.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] kmemleak: Add the slab memory allocation/freeing
 hooks
In-Reply-To: <1229619764.16418.54.camel@pc1117.cambridge.arm.com>
Message-ID: <Pine.LNX.4.64.0812181334590.17255@quilx.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com> 
 <20081210182710.30323.57396.stgit@pc1117.cambridge.arm.com> 
 <494184AA.8090509@cs.helsinki.fi>  <1229092065.15045.35.camel@pc1117.cambridge.arm.com>
  <1229597162.1047.48.camel@penberg-laptop>  <1229618308.16418.50.camel@pc1117.cambridge.arm.com>
  <Pine.LNX.4.64.0812181048160.12300@quilx.com> <1229619764.16418.54.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008, Catalin Marinas wrote:

> OK, but is there a chance that an stale pointer remains in such caches?

Definitely. The pointers are never cleared. There are counters in the
caches that are used to index into an array.

> There seems to be the transfer_objects() function that moves pointers
> around but doesn't clear the source values.

No need to. The counter updates take care of things.

