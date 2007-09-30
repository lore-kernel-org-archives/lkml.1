Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbXI3WIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbXI3WIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 18:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbXI3WIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 18:08:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:34248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbXI3WII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:08:08 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] [20/45] x86_64: Use 8 byte stack alignment when possible
Date: Mon, 1 Oct 2007 00:07:59 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200709211044.901175000@suse.de> <20070921204502.2C61D14EFF@wotan.suse.de> <20070921211935.GW2625@devserv.devel.redhat.com>
In-Reply-To: <20070921211935.GW2625@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710010007.59574.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 September 2007 23:19:35 Jakub Jelinek wrote:
> On Fri, Sep 21, 2007 at 10:45:02PM +0200, Andi Kleen wrote:
> > 
> > Kernel doesn't use SSE2, so it doesn't need 16 byte alignment. Also
> > the stack can be already unaligned so letting the compiler align
> > is useless. This may make some stack frames smaller.
> 
> Shouldn't sources that are compiled into the VDSO or VSYSCALL pages
> revert this to the default?

I see not reason. vdso/vsyscall don't contain any SSE code and also don't 
do any callbacks to other user code. Except for signals and signals 
already align the stack by themselves.

-Andi
