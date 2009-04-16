Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbZDPQ3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbZDPQ3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZDPQ30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:29:26 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47312 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbZDPQ3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:29:25 -0400
Date: Thu, 16 Apr 2009 11:29:10 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, Dave Hansen <dave@linux.vnet.ibm.com>,
       xemul@parallels.com, containers@lists.linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: CAP_SYS_ADMIN on restart(2)
Message-ID: <20090416162910.GA20736@us.ibm.com>
References: <20090414145830.GA27461@x200.localdomain> <49E4D115.5080601@cs.columbia.edu> <20090414204912.GA28458@x200.localdomain> <20090414213934.GB17986@us.ibm.com> <20090415192150.GC26994@x200.localdomain> <1239827033.32604.167.camel@nimitz> <20090415203920.GA5475@us.ibm.com> <49E64BFF.5080002@cs.columbia.edu> <20090415211609.GA6704@us.ibm.com> <20090416153513.GA7876@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416153513.GA7876@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > What Alexey wants, I believe, is for users to be able to not have
> > to worry about there being exploitable bugs in restart(2) which
> > unprivileged users can play with.  And for the usual distro-kernel
> > reasons, saying use 'CONFIG_CHECKPOINT=n' is not an option.
> 
> This is correct, yes. If I would be a sysadmin who knows a bit about
> kernel internals, I'd never trust restart(2) to get it right.

Now I suppose what we could do is define a new CAP_SYS_RESTART
capability and require that.  Then the admin to whom I'm trying
to cater could simply 'capset cap_sys_restart=pe /bin/restart'.
Then all users could use restart without being granted the
extra privilege implied by CAP_SYS_ADMIN.

-serge
