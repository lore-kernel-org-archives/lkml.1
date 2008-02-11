Return-Path: <linux-kernel-owner+w=401wt.eu-S1760315AbYBKS3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315AbYBKS3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760002AbYBKS3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:29:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36581 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315AbYBKS3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:29:13 -0500
Date: Mon, 11 Feb 2008 20:04:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Prevent IDE boot ops on NUMA system in mainline
Message-ID: <20080211190438.GB21824@one.firstfloor.org>
References: <20080211003520.GA32082@basil.nowhere.org> <alpine.LFD.1.00.0802110929230.2920@woody.linux-foundation.org> <alpine.LFD.1.00.0802110936231.2920@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802110936231.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 09:37:18AM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 11 Feb 2008, Linus Torvalds wrote:
> > 
> > So we should probably make pcibus_to_node() be an inline function for that 
> > case
> 
> Or, we could just do the ugliest patch ever, namely
> 
> 	-#define pcibus_to_node(node)   (-1)
> 	+#define pcibus_to_node(node)   ((int)(long)(node),-1)
> 
> Wow. It's so ugly it's almost wraps around and comes out the other sides 
> and looks pretty.

(void)arg, ... is better. Trick originally from Jan Beulich I think
(his code is always a good source for useful new C tricks) 

-Andi

