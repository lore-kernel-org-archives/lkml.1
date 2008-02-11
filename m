Return-Path: <linux-kernel-owner+w=401wt.eu-S1760164AbYBKRh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164AbYBKRh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYBKRhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:37:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57330 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758656AbYBKRhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:37:48 -0500
Date: Mon, 11 Feb 2008 09:37:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Prevent IDE boot ops on NUMA system in mainline
In-Reply-To: <alpine.LFD.1.00.0802110929230.2920@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802110936231.2920@woody.linux-foundation.org>
References: <20080211003520.GA32082@basil.nowhere.org> <alpine.LFD.1.00.0802110929230.2920@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Feb 2008, Linus Torvalds wrote:
> 
> So we should probably make pcibus_to_node() be an inline function for that 
> case

Or, we could just do the ugliest patch ever, namely

	-#define pcibus_to_node(node)   (-1)
	+#define pcibus_to_node(node)   ((int)(long)(node),-1)

Wow. It's so ugly it's almost wraps around and comes out the other sides 
and looks pretty.

		Linus
