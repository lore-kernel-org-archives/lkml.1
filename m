Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbZGXG4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbZGXG4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 02:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbZGXG4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 02:56:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51656 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZGXG4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 02:56:05 -0400
Date: Fri, 24 Jul 2009 08:56:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sage Weil <sage@newdream.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-fsdevel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/19] ceph: address space operations
Message-ID: <20090724065603.GA2045@basil.fritz.box>
References: <1248292313-31326-4-git-send-email-sage@newdream.net> <1248292313-31326-5-git-send-email-sage@newdream.net> <1248292313-31326-6-git-send-email-sage@newdream.net> <1248292313-31326-7-git-send-email-sage@newdream.net> <1248292313-31326-8-git-send-email-sage@newdream.net> <1248292313-31326-9-git-send-email-sage@newdream.net> <874ot33ddd.fsf@basil.nowhere.org> <Pine.LNX.4.64.0907231122070.2930@cobra.newdream.net> <1248374834.6139.13.camel@heimdal.trondhjem.org> <Pine.LNX.4.64.0907231642590.2930@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907231642590.2930@cobra.newdream.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The part I don't understand is what actually happens to pages after the 
> error flag set.  They're still uptodate, but no longer dirty?  And can be 
> overwritten/redirtied?  There's also an error flag on the address_space.  
> Are there any guidelines as far as which should be used?

Ideally both. The Page error flag prevents the data from being
consumed and the address space error flag makes sure errors are 
getting reported on fsync()/close() etc.  Also AS error is useful when
you don't have a clear page to assign the error to, e.g. if you
get an error indication that's not tied to a read operation.

BTW the upcoming hwpoison code can set such errors asynchronously
under you.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
