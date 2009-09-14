Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbZINXk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbZINXk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 19:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757493AbZINXkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 19:40:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753655AbZINXkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 19:40:24 -0400
Date: Mon, 14 Sep 2009 16:39:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Daney <ddaney@caviumnetworks.com>
cc: Brian Gerst <brgerst@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 11/11] Use unreachable() in asm-generic/bug.h for 
 !CONFIG_BUG case.
In-Reply-To: <4AAED18E.7030903@caviumnetworks.com>
Message-ID: <alpine.LFD.2.01.0909141637250.4950@localhost.localdomain>
References: <4AAEBAC2.1050905@caviumnetworks.com>  <1252965340-31735-11-git-send-email-ddaney@caviumnetworks.com> <73c1f2160909141612i32f46361q7430cecf0b68d07b@mail.gmail.com> <4AAED18E.7030903@caviumnetworks.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Sep 2009, David Daney wrote:
> 
> The existing code just falls through to whatever happens to follow the BUG().

Brian was talking BUG_ON().

And the existing !CONFIG_BUG BUG_ON() is actually set up so that gcc will 
just optimize it away entirely (yet give the same compile-time warnings as 
the "real" BUG_ON() does).

Changing it to "if (cond) unreachable()" is likely to generate _more_ 
code, which is against the whole point of wanting to disable CONFIG_BUG.

			Linus
