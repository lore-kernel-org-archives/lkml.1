Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbYAPXXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbYAPXXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757210AbYAPXSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:18:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41174 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756339AbYAPXSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:18:42 -0500
Date: Wed, 16 Jan 2008 15:18:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
In-Reply-To: <Pine.LNX.4.64.0801161419290.11922@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.1.00.0801161517090.2806@woody.linux-foundation.org>
References: <87lk6pvii0.fsf@saeurebad.de> <alpine.LFD.1.00.0801161026550.2806@woody.linux-foundation.org> <87odblct19.fsf@saeurebad.de> <Pine.LNX.4.64.0801161419290.11922@schroedinger.engr.sgi.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jan 2008, Christoph Lameter wrote:
> 
> Correct and we have gcc 4.2 currently spitting out warnings because of 
> casting to non const. Any idea how to convince gcc that this is okay?

Either don't use a broken compiler (casting a const pointer to a non-const 
is definitely not a bug), or cast to "unsigned long" (if it still 
complains, now the compiler is not just stupid, it's broken).

The whole point of memory management is that we know how pointers work, 
and understand that they have a *bit* representation, not just the C 
semantics.

		Linus
