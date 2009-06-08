Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbZFHXQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbZFHXQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 19:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbZFHXQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 19:16:32 -0400
Received: from tundra.namei.org ([65.99.196.166]:56926 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbZFHXQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 19:16:31 -0400
Date: Tue, 9 Jun 2009 09:16:21 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Mimi Zohar <zohar@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       David Safford <safford@watson.ibm.com>
Subject: Re: [PATCH] integrity: fix IMA inode leak
In-Reply-To: <1244486655.3277.65.camel@dyn9002018117.watson.ibm.com>
Message-ID: <alpine.LRH.2.00.0906090912120.6132@tundra.namei.org>
References: <Pine.LNX.4.64.0906062109580.8365@sister.anvils>  <alpine.LFD.2.01.0906061416170.6847@localhost.localdomain>  <1244354901.3963.23.camel@dyn9002018117.watson.ibm.com>  <alpine.LFD.2.01.0906071608040.6847@localhost.localdomain> 
 <1244464135.3277.13.camel@dyn9002018117.watson.ibm.com>  <alpine.LFD.2.01.0906080913020.6847@localhost.localdomain> <1244486655.3277.65.camel@dyn9002018117.watson.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Mimi Zohar wrote:

> 
> Ok, so instead of having a full fledge single security layer, only add
> the security layer for those places where both the LSM hooks and IMA
> co-exist: security_file_mmap, security_bprm_check, security_inode_alloc,
> security_inode_free, and security_file_free. As the LSM hooks are called
> 'security_XXXX', the call would look something like:
> 
> security_all_inode_free() {
>         ima_inode_free()
>         security_inode_free()
> }

Yes, it only needs to be a wrapper.  The above is ugly, how about:

security_inode_free()
{
	ima_inode_free();
	lsm_inode_free();
}

I think we may have come full circle on the naming of the LSM hook, but 
'security_*' was never great given that it's only supposed to be covering 
access control.

-- 
James Morris
<jmorris@namei.org>
