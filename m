Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYFYUiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYFYUiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 16:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYFYUh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 16:37:57 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:40015 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbYFYUh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 16:37:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=QLRipHA1erp8O49xB6d7PSn42lXk4AsXrQRn8oC7/UKz3WETkqP5bN2cRAO0fMgQWL
         9yeE9VeyAS4PRy2FScjnqIn5OQTWCGwqWHIvAahKzY2DDcxTGxwGeltiIVC6OV54vPvM
         J3vkEj/rlZl7tU0U2D3OH6iC+nV/YTvSUIajA=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [3/10 PATCH] inline wake_up_bit
Date: Wed, 25 Jun 2008 22:37:58 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       davem@davemloft.net
References: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com> <200806251724.57689.vda.linux@googlemail.com> <Pine.LNX.4.64.0806251148550.20484@engineering.redhat.com>
In-Reply-To: <Pine.LNX.4.64.0806251148550.20484@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806252237.58046.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2008 18:01, Mikulas Patocka wrote:
> > Ingo's suggestion to talk to gcc people to remedy
> > insane call convention sounds as a more workable solution.
> >
> > BTW, i386 uses regparm call convention, is similar trick
> > possible for sparc64?
> 
> Sparc64 has register windows: it passes arguments in registers, but it 
> must allocate space for that registers. If the call stack is too deep (8 
> levels), the CPU runs out of registers and starts spilling the registers 
> of the function 8-levels-deep to the stack.
> 
> The stack usage could be reduced to 176 bytes with little work from gcc 
> developers and to 128 bytes with more work (ABI change). If you wanted to 

Wow, it's nearly x2 reduction.

ABI change in not a problem for kernel, since it is a "freestanding
application". Exactly like i386 switched to regparm, which is a different ABI.

> go below 128 bytes, you could use one register to indicate number of used 
> registers and modify the spill/fill handlers to load only that number of 
> registers and reduce the stack usage even more --- that would be a big 
> code change in both gcc and linux.
--
vda
