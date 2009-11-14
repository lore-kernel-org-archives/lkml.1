Return-Path: <linux-kernel-owner+w=401wt.eu-S932213AbZKNDJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbZKNDJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 22:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756373AbZKNDJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 22:09:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37008
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755465AbZKNDJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 22:09:38 -0500
Date: Fri, 13 Nov 2009 19:09:54 -0800 (PST)
Message-Id: <20091113.190954.189642997.davem@davemloft.net>
To: gregory.haskins@gmail.com
Cc: herbert@gondor.apana.org.au, ghaskins@novell.com, mst@redhat.com,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC PATCH] net: add dataref destructor to sk_buff
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AFE15AD.6000208@gmail.com>
References: <4AFE08EF.2030308@gmail.com>
	<20091114022103.GA19020@gondor.apana.org.au>
	<4AFE15AD.6000208@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <gregory.haskins@gmail.com>
Date: Fri, 13 Nov 2009 21:27:57 -0500

> Clearly there must be _some_ mechanism to synchronize (e.g.
> flush/barrier) though, right?  Otherwise, that interface would seem to
> be quite prone to races and would likely be unusable.   So what does
> said flush use to know when the buffer is free?

There is no such synchronization at all.

If some synchronization is required, it must be done at a higher
level.

For example, SAMBA can only use sendfile() to serve file contents when
the client holds an SMB "OP Lock" on the file.  Luckily, by default
pretty much all SMB client implementations hold the OP Lock on a file
even just to read it (this is so that self-modifying autoexec.bat
scripts work :-)

But frankly most sendfile() consumers don't care, and the only thing
that really matters is that the checksum on the final TCP packet that
goes out is correct, and since we require card checksums to sendfile()
without copying, that is taken care of transparently.
