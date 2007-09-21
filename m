Return-Path: <linux-kernel-owner+w=401wt.eu-S1763155AbXIUTy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763155AbXIUTy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761915AbXIUTyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:54:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:37945 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbXIUTys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:54:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=G5jZeNK5rHyxntZhO3nlpL1nFVRiFE4BuczJhecKRzA3RBazYiFQ1NNsw+YV3avDP1RPhukIhwCG5dbSFh/uDcXIBmhDG7OCQKSkRJCrzzIDciU1ltNA3D4nzWdETMT11hTkDYQifxc4sTF6RnhEQjt88J4JtuAwMAwtQfSHYUM=
Date: Fri, 21 Sep 2007 23:54:03 +0400
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, andrea@suse.de, clameter@sgi.com
Subject: Re: + oom-move-prototypes-to-appropriate-header-file.patch added to -mm tree
Message-ID: <20070921195403.GC1857@martell.zuzino.mipt.ru>
References: <200709210910.l8L9AttS028186@imap1.linux-foundation.org> <20070921170548.GA1857@martell.zuzino.mipt.ru> <alpine.DEB.0.9999.0709211236130.29079@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.9999.0709211236130.29079@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 12:38:03PM -0700, David Rientjes wrote:
> On Fri, 21 Sep 2007, Alexey Dobriyan wrote:
> 
> > > Move the OOM killer's extern function prototypes to include/linux/oom.h and
> > > include it where necessary.
> > > 
> > > Cc: Andrea Arcangeli <andrea@suse.de>
> > > Acked-by: Christoph Lameter <clameter@sgi.com>
> > 
> > NAK. Target in corresponding Kbuild is wrong. sched.h is overkill.
> > Could we please also drop extern's while in protos?
> > 
> 
> I'll prevent including sched.h in a follow-up patchset that I'll be 
> posting soon (and you'll be Cc'd).  Which Kbuild target are you referring 
> to?

It's header-y vs unifdef-y in include/linux/Kbuild. The former is for
plain headers exported to userspace as-is. The latter need preprocessing
to remove __KERNEL__, CONFIG_*, etc.

Since you're going to clutter oom.h with some purely internal protos,
preprocessing should be done as well ;-)
