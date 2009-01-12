Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbZALCby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbZALCby (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 21:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZALCbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 21:31:43 -0500
Received: from mail2.shareable.org ([80.68.89.115]:48232 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZALCbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 21:31:43 -0500
Date: Mon, 12 Jan 2009 02:31:38 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Grissiom <chaos.proton@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] async: Don't call async_synchronize_full_special()	while holding sb_lock
Message-ID: <20090112023138.GD6428@shareable.org>
References: <a0adeea50901080007q5a3ed5c8y5a744ce37e677325@mail.gmail.com> <1231425472.21528.13.camel@norville.austin.ibm.com> <20090108072111.1ebadebd@infradead.org> <1231429591.27353.14.camel@norville.austin.ibm.com> <20090108225050.GL9448@disturbed> <49668388.708@linux.intel.com> <20090109014054.GN9448@disturbed> <4966D652.4070105@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4966D652.4070105@linux.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> >	- removing a million files and queuing all of the
> >	  deletes in the async queues....
> 
> the async code throttles at 32k outstanding.
> Yes 32K is arbitrary, but if you delete  a million files fast, all but the 
> first few thousand are
> synchronous.

Hmm.

If I call unlink() a thousand times and then call fsync() on the
parent directories covering files I've unlinked... I expect the
deletes to be committed to disk when the last fsync() has returned.  I
require that a crash and restart will not see the files.  Several
kinds of transactional software and even some shell scripts expect this.

Will these asynchronous deletes break the guaranteed
commit-of-the-delete provided by fsync() on the parent directory?

-- Jamie
