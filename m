Return-Path: <linux-kernel-owner+w=401wt.eu-S965539AbXCFSVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965539AbXCFSVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965552AbXCFSVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:21:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965539AbXCFSVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:21:51 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <45EDABC8.8040901@zytor.com> 
References: <45EDABC8.8040901@zytor.com>  <20070306173929.2708.37191.stgit@warthog.cambridge.redhat.com> 
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: torvalds@osdl.org, akpm@osdl.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] Fix get_order() 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 06 Mar 2007 18:21:39 +0000
Message-ID: <3523.1173205299@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa@zytor.com> wrote:

> 	if (size <= (1UL << page_shift))
> 		return 0;
> 	else
> 		return __ilog2_u32(size-1)+1-page_shift;

I think you're right.  That'll also defend against the result of __ilog2_u32()
being less than page_shift-1.

I think I can dispense with the page_shift argument.  IIRC __get_order() was
overridden by some arch, but isn't now.

David
