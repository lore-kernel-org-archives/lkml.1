Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbZHKPs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbZHKPs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZHKPs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:48:58 -0400
Received: from relay1.sgi.com ([192.48.179.29]:60251 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751976AbZHKPs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:48:57 -0400
Date: Tue, 11 Aug 2009 10:48:53 -0500
From: Robin Holt <holt@sgi.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: System freeze on reboot - general protection fault
Message-ID: <20090811154853.GF2763@sgi.com>
References: <c4e36d110908110542l3de51aaepcbd62c84b9848f2b@mail.gmail.com> <alpine.DEB.1.10.0908111032110.30494@gentwo.org> <c4e36d110908110752x253e30epb00cc71f4683052b@mail.gmail.com> <alpine.DEB.1.10.0908111056550.30494@gentwo.org> <c4e36d110908110832y21fba830ub8804613df571228@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c4e36d110908110832y21fba830ub8804613df571228@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 05:32:16PM +0200, Zdenek Kabelac wrote:
> 2009/8/11 Christoph Lameter <cl@linux-foundation.org>:
> > On Tue, 11 Aug 2009, Zdenek Kabelac wrote:
> >
> >> Well - I've tried to switch from  'slub' allocator to  old 'slab'
> >> allocator and the problem is gone - shutdown goes without any problem.
> >>
> >> So it's probably related to 'slub' allocator only?
> >
> > The slab allocator does not have all the diagnostics of slub. The issue
> > may simply not be detected in slab. If you switch off diagnostics in slub
> > then everything will seem to work fine as well. But we need to figure out
> > what is going wrong here.
> 
> Hmm - but there are few things -
> 
> My machine runs  Fedora Rawhide. If I run the same kernel within KVM
> running Debian unstable I could easily reboot this guest machine
> without any problems.
> 
> Also if I boot Rawhide only to single mode - I could also reboot
> machine without this oops.
> The problem seems to be - when I do full machine startup to the
> multiuser runlevel 3

Try booting all the way and recording you output from lsmod.  Reboot
single user mode and modprobe each of the modules in that original lists.
Test shutdown from single user mode.  This might identify if it is one
of your loaded modules.  If so, effectively bisect the modprobes until
you find the offending module(s).

Robin
