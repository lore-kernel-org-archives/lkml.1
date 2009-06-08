Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbZFHM3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbZFHM3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 08:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbZFHM24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 08:28:56 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50129 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbZFHM2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 08:28:55 -0400
Subject: Re: [PATCH] integrity: fix IMA inode leak
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mimi Zohar <zohar@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>, James Morris <jmorris@namei.org>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Safford <safford@watson.ibm.com>
In-Reply-To: <alpine.LFD.2.01.0906071608040.6847@localhost.localdomain>
References: <Pine.LNX.4.64.0906062109580.8365@sister.anvils>
	 <alpine.LFD.2.01.0906061416170.6847@localhost.localdomain>
	 <1244354901.3963.23.camel@dyn9002018117.watson.ibm.com>
	 <alpine.LFD.2.01.0906071608040.6847@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 08:28:55 -0400
Message-Id: <1244464135.3277.13.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-07 at 16:09 -0700, Linus Torvalds wrote:
> 
> On Sun, 7 Jun 2009, Mimi Zohar wrote:
> > 
> > Mandatory Access Control(MAC) modules (i.e. SELinux, smack, etc) and
> > integrity (i.e IMA) are two different aspects of security.  The LSM
> > hooks, which includes security_inode_free(), are used to implement MAC,
> > not integrity.
> 
> So?
> 
> It's under security/integrity. And it's a level of detail that fs/inode.c 
> really doesn't care about.
> 
> The VFS layer cares NOT AT ALL about your "different aspects of security", 
> nor should it. The fact that security people think SELinux and IMA are 
> different is irrelavant - fs/inode.c just doesn't care. Why should it?
> 
> 		Linus

Today the security calls are synomymous with MAC.  If I understand
correctly, you're suggesting we need to have a single security layer,
which, depending on the hook, calls either MAC or integrity, or both.

Makes sense. Copying the LSM mailing list on this discussion.

Mimi Zohar

