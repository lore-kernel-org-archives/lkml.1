Return-Path: <linux-kernel-owner+w=401wt.eu-S1760183AbXI1BGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183AbXI1BGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 21:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbXI1BGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 21:06:16 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34531 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbXI1BGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 21:06:16 -0400
Message-ID: <46FC5381.409@davidnewall.com>
Date: Fri, 28 Sep 2007 10:36:09 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Theodore Tso <tytso@mit.edu>, Christer Weinigel <christer@weinigel.se>,
       Al Viro <viro@ftp.linux.org.uk>, Phillip Susi <psusi@cfl.rr.com>,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
References: <20070919194559.36015307@the-village.bc.nu> <46F1A196.8060108@davidnewall.com> <46F401D6.6060609@cfl.rr.com> <20070921191012.15a0b51b@the-village.bc.nu> <46F9752C.5080807@cfl.rr.com> <20070926002340.GL8181@ftp.linux.org.uk> <46FA35A6.1070400@davidnewall.com> <20070926212408.6662231a@zoo.weinigel.se> <46FACCE0.2070005@davidnewall.com> <20070927092808.612c204b@localhost.localdomain> <20070927112316.GC18346@thunk.org> <46FBBFD5.6050702@tmr.com>
In-Reply-To: <46FBBFD5.6050702@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote: 
> It seems there are (at least) two parts to this, one regarding 
> changing working directory which is clearly stated in the standards 
> and must work as it does, and the various issues regarding getting out 
> of the chroot after the cwd has entered that changed root. That second 
> part seems to offer room for additional controls on getting out of the 
> chroot which do not violate any of the obvious standards, and which 
> therefore might be valid candidates for discussion on the basis of 
> benefit rather than portability.

Correct.  BSDs solved the problem by changing cwd on subsequent use of 
chroot; I think there's a better way.  I think the solution might be to 
add a "previous root", and restrict the process there as well as the new 
root.  That is, once cwd is set within the new root, that new root is 
the limit.  Prior to setting cwd within the new root, the previous root 
is the limit.
