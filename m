Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879AbYKFT7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbYKFT7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYKFT7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:59:11 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37381 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbYKFT7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:59:10 -0500
Date: Thu, 6 Nov 2008 13:58:56 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com, sgrubb@redhat.com,
       morgan@kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH -v2 3/4] AUDIT: collect info when execve results in
	caps in pE
Message-ID: <20081106195856.GA30017@us.ibm.com>
References: <20081103201742.12059.36030.stgit@paris.rdu.redhat.com> <20081103201753.12059.67262.stgit@paris.rdu.redhat.com> <20081104163540.GA24318@us.ibm.com> <1225999615.3300.177.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225999615.3300.177.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> So here's the problem....  I can't fail this syscall, it's too late.  I

Oh, right...

> can do a couple of things.
> 
> 1) waste lots of space in the execve record so we know memory has
> already been allocated
> 2) just ignore the memory failure and don't worry about it.  We are
> still going to get the fcaps info from the patch record and should be
> able to piece together the starting and finishing caps by looking at
> past audit records if you really need it.
> 3) I can call audit_log_lost().  I don't think we know are this time
> that we really needed this record, but this is the 'safest' approach.
> If people have their machines set to panic on lost records we would
> panic.   Honestly though, if we don't have enough memory to satisfy this
> request (we're talking about 72 bytes or something?) we are going to
> fail the next audit message, so doing it now would be just fine.
> 
> I vote #2 since I don't think we are really going to have any lose of
> info.  But if people want it I'll go #3 since I don't think it will hurt
> anything.

2 sounds reasonable to me.  Reckon sgrubb will speak up if it violates
some audit requirement.

thanks,
-serge
