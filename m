Return-Path: <linux-kernel-owner+w=401wt.eu-S1762854AbZDBSs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762854AbZDBSs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbZDBSss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:48:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42405 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbZDBSsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:48:47 -0400
Date: Thu, 2 Apr 2009 19:48:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nick Piggin <npiggin@suse.de>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/2] fs: mnt_want_write speedup
Message-ID: <20090402184844.GA2080@ZenIV.linux.org.uk>
References: <20090310143718.GB15977@wotan.suse.de> <1236809477.30142.83.camel@nimitz> <20090312041334.GB1893@wotan.suse.de> <1237403623.8286.196.camel@nimitz> <20090402182210.GB17175@wotan.suse.de> <20090402184305.GI28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402184305.GI28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 07:43:05PM +0100, Al Viro wrote:

> FWIW, I'm not sure that this optimization is valid.  We might eventually
> want to go for "don't allow any new writers, remount r/o when existing
> ones expire" functionality, so nested mnt_want_write() might eventually
> be allowed to fail.

BTW, I think that 1/2 as of Mar 10 is worth merging.  There's an interesting
question, though - do we want mnt_writers int or long?  On 64bit boxen it
can get serious...
