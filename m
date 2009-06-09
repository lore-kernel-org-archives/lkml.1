Return-Path: <linux-kernel-owner+w=401wt.eu-S1752830AbZFIC5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbZFIC5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 22:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZFIC4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 22:56:54 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48677 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbZFIC4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 22:56:53 -0400
Subject: Re: [PATCH] integrity: fix IMA inode leak
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Mimi Zohar <zohar@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       David Safford <safford@watson.ibm.com>
In-Reply-To: <alpine.LRH.2.00.0906090912120.6132@tundra.namei.org>
References: <Pine.LNX.4.64.0906062109580.8365@sister.anvils>
	 <alpine.LFD.2.01.0906061416170.6847@localhost.localdomain>
	 <1244354901.3963.23.camel@dyn9002018117.watson.ibm.com>
	 <alpine.LFD.2.01.0906071608040.6847@localhost.localdomain>
	 <1244464135.3277.13.camel@dyn9002018117.watson.ibm.com>
	 <alpine.LFD.2.01.0906080913020.6847@localhost.localdomain>
	 <1244486655.3277.65.camel@dyn9002018117.watson.ibm.com>
	 <alpine.LRH.2.00.0906090912120.6132@tundra.namei.org>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 22:56:51 -0400
Message-Id: <1244516211.3804.24.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-09 at 09:16 +1000, James Morris wrote:
> On Mon, 8 Jun 2009, Mimi Zohar wrote:
> 
> > 
> > Ok, so instead of having a full fledge single security layer, only add
> > the security layer for those places where both the LSM hooks and IMA
> > co-exist: security_file_mmap, security_bprm_check, security_inode_alloc,
> > security_inode_free, and security_file_free. As the LSM hooks are called
> > 'security_XXXX', the call would look something like:
> > 
> > security_all_inode_free() {
> >         ima_inode_free()
> >         security_inode_free()
> > }
> 
> Yes, it only needs to be a wrapper.  The above is ugly, how about:

agreed!  But changing only these 5 security_ hook names and leaving the
rest alone is even uglier.

> security_inode_free()
> {
> 	ima_inode_free();
> 	lsm_inode_free();
> }
> 
> I think we may have come full circle on the naming of the LSM hook, but 
> 'security_*' was never great given that it's only supposed to be covering 
> access control.

so why not 'mac_'?

Mimi Zohar

