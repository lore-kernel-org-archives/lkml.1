Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbZFHQPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbZFHQPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 12:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbZFHQPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 12:15:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754961AbZFHQPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 12:15:38 -0400
Date: Mon, 8 Jun 2009 09:15:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mimi Zohar <zohar@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>, James Morris <jmorris@namei.org>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Safford <safford@watson.ibm.com>
Subject: Re: [PATCH] integrity: fix IMA inode leak
In-Reply-To: <1244464135.3277.13.camel@dyn9002018117.watson.ibm.com>
Message-ID: <alpine.LFD.2.01.0906080913020.6847@localhost.localdomain>
References: <Pine.LNX.4.64.0906062109580.8365@sister.anvils>  <alpine.LFD.2.01.0906061416170.6847@localhost.localdomain>  <1244354901.3963.23.camel@dyn9002018117.watson.ibm.com>  <alpine.LFD.2.01.0906071608040.6847@localhost.localdomain>
 <1244464135.3277.13.camel@dyn9002018117.watson.ibm.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Jun 2009, Mimi Zohar wrote:
> 
> Today the security calls are synomymous with MAC.  If I understand
> correctly, you're suggesting we need to have a single security layer,
> which, depending on the hook, calls either MAC or integrity, or both.

I don't think we need a single security layer per se.

But I do think that we _already_ hide IMA conceptually under the 
"security/" subdirectory, and that the VFS layer shouldn't need to care 
about whatever internal details.

We should not have generic code end up having to know about all the 
details, when we already have a conceptual nesting. It would be much 
better for generic code to just have to worry about one security hook that 
then encompasses all the models, than having several different hooks for 
each detail.

		Linus
