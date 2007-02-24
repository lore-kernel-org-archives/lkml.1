Return-Path: <linux-kernel-owner+w=401wt.eu-S933315AbXBXBbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315AbXBXBbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 20:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933316AbXBXBbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 20:31:37 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:55258 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315AbXBXBbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 20:31:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BB7fvpzpU697nApxUpMCWEU4GD3nxk2JcHm0U0YYwF3Yvx17p7HygsO9FS24zZM+IrY8hiP+tG1ZzjfOj4dMWT/sxrmxDIzMb9YjfHTlfjB6AQbyinjjvAnxaJ0AbKMfvWJ5R6DN2OTlaDBF6G0VRGedtTEqjGvCERn1RHD3Bgc=
Message-ID: <f2b55d220702231731l10d36e66h67dd185feb52e8a5@mail.gmail.com>
Date: Fri, 23 Feb 2007 17:31:30 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Zach Brown" <zab@zabbo.net>
Subject: Re: [rfc][patch] dynamic resizing dentry hash using RCU
Cc: "Nick Piggin" <npiggin@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <5FD7605C-E132-4893-86FA-F76DDFB16389@zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070223153743.GA26141@wotan.suse.de>
	 <5FD7605C-E132-4893-86FA-F76DDFB16389@zabbo.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/23/07, Zach Brown <zab@zabbo.net> wrote:
> I'd love to see a generic implementation of RCU hashing that
> subsystems can then take advantage of.  It's long been on the fun
> side of my todo list.  The side I never get to :/.

There's an active thread on netdev about implementing an RCU hash.
I'd suggest a 2-left (or possibly even k-left) hash for statistical
reasons discussed briefly there, and in greater depth in a paper by
Michael Mitzenmacher at
www.eecs.harvard.edu/~michaelm/NEWWORK/postscripts/iproute.ps.
Despite his paper's emphasis on hardware parallelism, there's a bigger
win associated with Poisson statistics and decreasing occupation
fraction (and therefore collision probability) in successive hashes.

Cheers,
- Michael
