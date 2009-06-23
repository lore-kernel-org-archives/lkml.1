Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbZFWR5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbZFWR5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbZFWR5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:57:38 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:39406 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbZFWR5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:57:37 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 23 Jun 2009 10:51:28 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, avi@redhat.com,
       kvm@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin LaHaise <bcrl@kvack.org>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch] eventfd - revised interface and cleanups
In-Reply-To: <4A411636.3010903@novell.com>
Message-ID: <alpine.DEB.1.10.0906231049520.17001@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com> <4A411636.3010903@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Gregory Haskins wrote:

> I think the lack of a way to got from a file* to a ctx* (or back) might
> be a problem.  I am not an expert, but if I understood the gist of what
> Al Viro (cc'd) was saying early on, an fd can change meaning out from
> under you without warning.
> 
> With the code the way it is now, I would need to call both
> eventfd_fget() and eventfd_ctx_fdget() to fully acquire state (unless I
> am missing something).  I would think that is a race and I am not
> guaranteed to get the same object.  Can we also have a way to convert
> one reference to the other?  I am thinking
> 
> struct eventfd_ctx *eventfd_ctx_fget(struct file *)
> 
> (or similar) would be sufficient.

You're right. That function was available in the previous patch, but then 
I dropped it because I thought the eventfd code could be simplified. But 
yes, it's needed.



- Davide


