Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbZDYTbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbZDYTbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 15:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbZDYTbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 15:31:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42282 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbZDYTbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 15:31:41 -0400
Date: Sat, 25 Apr 2009 20:31:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@infradead.org>, npiggin@suse.de,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/27] [rfc] vfs scalability patchset
Message-ID: <20090425193133.GB8633@ZenIV.linux.org.uk>
References: <20090425012020.457460929@suse.de> <20090425041829.GX8633@ZenIV.linux.org.uk> <20090425080143.GA29033@infradead.org> <m1tz4ctuu7.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tz4ctuu7.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 12:08:16PM -0700, Eric W. Biederman wrote:

> Can we?  My first glance at that code I asked myself if we could examine
> i_writecount, instead of going to the file. My impression was that we
> were deliberately only counting persistent write references from files

No, there's nothing deliberate about that.  The code is simply wrong;
some of that crap had been fixed with mnt_want_write series, but
the rest...

> instead of transient write references.  As only the persistent write
> references matter.  Transient write references can at least in theory
> be flushed as the filesystem is remounting read-only.

No.  It's far too painful to do and no fs is doing that.  You are looking
for deliberate behaviour in a place where we have a half-fixed pile of races.
