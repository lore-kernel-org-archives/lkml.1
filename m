Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbZJVAsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbZJVAsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 20:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbZJVAsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 20:48:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45119 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbZJVAsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 20:48:07 -0400
Date: Thu, 22 Oct 2009 02:48:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org, randy.dunlap@oracle.com,
       rusty@rustcorp.com.au, andi@firstfloor.org, dhowells@redhat.com,
       akpm@linux-foundation.org
Subject: Re: request_module vs. modprobe blacklist (and security subsystem implications)
Message-ID: <20091022004810.GS32470@one.firstfloor.org>
References: <1256137348.4443.39.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256137348.4443.39.camel@dhcp231-106.rdu.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem is that a number of programs (sendmail, procmail, sshd, and
> more) have all been seen to do operations which tried to load the ipv6
> module.  These get into request_module(), hit the security hook, and are
> obviously denied since the security system doesn't see a need for those
> programs to be able to request a module be loaded.

What's the problem with being denied? After all the programs expect
this to error out

If you're worrying about the audit entries -- the obvious place
to fix that is somewhere in your security code. Don't make the rest
of the code uglier for this.

-Andi
