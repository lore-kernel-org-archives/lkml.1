Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbXDKKpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbXDKKpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 06:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbXDKKpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 06:45:51 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:47541 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbXDKKpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 06:45:50 -0400
To: linuxram@us.ibm.com
CC: serue@us.ibm.com, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <1176194285.2903.67.camel@ram.us.ibm.com> (message from Ram Pai
	on Tue, 10 Apr 2007 01:38:04 -0700)
Subject: Re: [patch 0/8] unprivileged mount syscall
References: <20070404183012.429274832@szeredi.hu>
	 <20070406160238.f3178189.akpm@linux-foundation.org>
	 <E1Ha4cN-0004rc-00@dorka.pomaz.szeredi.hu>
	 <20070409143802.GB4891@sergelap.austin.ibm.com>
	 <E1Hawf4-0000E7-00@dorka.pomaz.szeredi.hu>
	 <20070409170743.GF24415@sergelap.austin.ibm.com>
	 <E1Hb0CH-0000nX-00@dorka.pomaz.szeredi.hu> <1176194285.2903.67.camel@ram.us.ibm.com>
Message-Id: <E1HbaJV-00059N-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 11 Apr 2007 12:44:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. clone the master namespace.
> 
> 2. in the new namespace
> 
> 	move the tree under /share/$me to /
>         for each ($user, $what, $how) {
>             move /share/$user/$what to /$what
> 	    if ($how == slave) {
>                  make the mount tree under /$what as slave
>             }
>         }
>         
> 3. in the new namespace make the tree under 
>        /share as private and unmount /share

Thanks.  I get the basic idea now: the namespace itself need not be
shared between the sessions, it is enough if "share" propagation is
set up between the different namespaces of a user.

I don't yet see either in your or Viro's description how the trees
under /share/$USER are initialized.  I guess they are recursively
bound from /, and are made slaves.

Miklos
