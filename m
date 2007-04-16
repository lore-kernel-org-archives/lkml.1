Return-Path: <linux-kernel-owner+w=401wt.eu-S1030266AbXDPJ2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030266AbXDPJ2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 05:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030283AbXDPJ2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 05:28:22 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:59666 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030266AbXDPJ2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 05:28:21 -0400
To: linuxram@us.ibm.com
CC: serue@us.ibm.com, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <1176711509.9488.4.camel@ram.us.ibm.com> (message from Ram Pai on
	Mon, 16 Apr 2007 01:18:29 -0700)
Subject: Re: [patch 0/8] unprivileged mount syscall
References: <20070406160238.f3178189.akpm@linux-foundation.org>
	 <E1Ha4cN-0004rc-00@dorka.pomaz.szeredi.hu>
	 <20070409143802.GB4891@sergelap.austin.ibm.com>
	 <E1Hawf4-0000E7-00@dorka.pomaz.szeredi.hu>
	 <20070409170743.GF24415@sergelap.austin.ibm.com>
	 <E1Hb0CH-0000nX-00@dorka.pomaz.szeredi.hu>
	 <1176194285.2903.67.camel@ram.us.ibm.com>
	 <E1HbaJV-00059N-00@dorka.pomaz.szeredi.hu>
	 <1176316116.2811.39.camel@ram.us.ibm.com>
	 <E1HcKQd-0001yO-00@dorka.pomaz.szeredi.hu>
	 <20070413132832.GA1483@sergelap.austin.ibm.com>
	 <E1HcMOq-0002As-00@dorka.pomaz.szeredi.hu> <1176711509.9488.4.camel@ram.us.ibm.com>
Message-Id: <E1HdNUv-0006gt-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 16 Apr 2007 11:27:45 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Arn't there ways to escape chroot jails? Serge had pointed me to a URL
> which showed chroots can be escaped. And if that is true than having all
> user's private mount tree in the same namespace can be a security issue?

No.  In fact chrooting the user into /share/$USER will actually
_grant_ a privilege to the user, instead of taking it away.  It allows
the user to modify it's root namespace, which it wouldn't be able to
in the initial namespace.

So even if the user could escape from the chroot (which I doubt), s/he
would not be able to do any harm, since unprivileged mounting would be
restricted to /share.  Also /share/$USER should only have read/search
permission for $USER or no permissions at all, which would mean, that
other users' namespaces would be safe from tampering as well.

Miklos
