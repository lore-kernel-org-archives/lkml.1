Return-Path: <linux-kernel-owner+w=401wt.eu-S1760668AbXGCQeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760668AbXGCQeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbXGCQd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:33:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:54193 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755799AbXGCQd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:33:57 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [AppArmor 00/44] AppArmor security module overview
Date: Tue, 3 Jul 2007 18:33:11 +0200
User-Agent: KMail/1.9.5
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <m1sl86iwkq.fsf@ebiederm.dsl.xmission.com> <997814.45234.qm@web36605.mail.mud.yahoo.com> <20070702201534.GA4896@infradead.org>
In-Reply-To: <20070702201534.GA4896@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2189
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707031833.12058.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 July 2007 22:15, Christoph Hellwig wrote:
> AA on the other hand just fucks up VFS layering [...]

Oh come on, this claim clearly isn't justified. How on earth is passing 
vfsmounts down the lsm hooks supposed to break vfs layering? We are not 
proposing to pass additional information down to file systems. There is no 
barrier between the vfs and lsm hooks for vfsmounts even today -- only look 
at the inode_getattr hook; it already gets a vfsmount.

Without vfsmount we cannot tell where in the namespace we are, but that 
information is essential for any kind of pathname based mechanism, AA or not, 
and even for plain reporting.

LSM as a framework is supposed to allow different security mechanisms to be 
plugged in. It isn't flexible enough for us right now, and so we are 
proposing to extend it. What can be wrong about that?

Andreas
