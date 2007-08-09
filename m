Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbXHISwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbXHISwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbXHISwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:52:08 -0400
Received: from namei.org ([69.55.235.186]:41567 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757188AbXHISwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:52:06 -0400
Date: Thu, 9 Aug 2007 11:50:57 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Casey Schaufler <casey@schaufler-ca.com>
cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org, akpm@osdl.org,
       steved@redhat.com, trond.myklebust@fys.uio.no,
       linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] CacheFiles: Permit an inode's security ID to be
 obtained [try #2]
In-Reply-To: <162335.27499.qm@web36605.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0708091143440.19611@us.intercode.com.au>
References: <162335.27499.qm@web36605.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Casey Schaufler wrote:

> This is SELinux specific functionality. It should not be an LSM
> interface. 

As long as the security labels are themselves not being exported to the 
kernel to be used e.g. for display or transport, then I agree, and we 
should avoid passing them around outside the LSM entirely if possible.

Usually, they're attached to a significant kernel object, which you 
typically pass around as part of the interface anyway.

David, I've looked at the code and can't see that you need to access the 
label itself outside the LSM.  Could you instead simply pass the inode 
pointer around?

(I know it's not always possible, but much preferred).


- James
-- 
James Morris
<jmorris@namei.org>
