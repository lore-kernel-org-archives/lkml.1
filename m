Return-Path: <linux-kernel-owner+w=401wt.eu-S1752098AbYJXEEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbYJXEEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbYJXEEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:04:39 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:22827 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbYJXEEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:04:38 -0400
From: Andrey Mirkin <major@openvz.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [Devel] Re: [PATCH 08/10] Introduce functions to restart a process
Date: Fri, 24 Oct 2008 08:04:41 +0400
User-Agent: KMail/1.8.2
Cc: Cedric Le Goater <clg@fr.ibm.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>
References: <1224285098-573-1-git-send-email-major@openvz.org> <200810231354.47033.major@openvz.org> <1224769753.12673.12.camel@nimitz>
In-Reply-To: <1224769753.12673.12.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810240804.42500.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2008 17:49 Dave Hansen wrote:
> On Thu, 2008-10-23 at 13:54 +0400, Andrey Mirkin wrote:
> > We are putting special structure on stack, which is used at the very end
> > of the whole restart procedure to restore complex states (ptrace is one
> > of such cases). Right now I don't need to use this structure as we have a
> > deal with simple cases, but reservation of 256 bytes on stack is needed
> > for future.
>
> Wow.  So you're saying that, if this patch is accepted, we simply need
> to accept that anything being checkpointed will use an extra 256 bytes
> of stack?  Seems like something to perhaps put in the changelog rather
> than some completely undocumented assembly nugget.

This 256 bytes will be used only during restart procedure and only by our 
module. As you can see in i386_ret_from_resume we are restoring it back. So, 
when process will return to user space it will not have extra 256 bytes 
reserved on stack already. I will add information about it to documentation 
and changelog.

Andrey
