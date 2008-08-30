Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbYH3Wjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbYH3Wjj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 18:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbYH3Wjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 18:39:32 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:36227 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbYH3Wjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 18:39:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=pY0f1Wo/tfHve9250jrt4LueV3h/sORbLFPwJ46w2CxTCNTr4jT7btCJ/IPjzkuhTH
         TI29p/HyPXWF80aujqPkUDcWBoH7Pu1IdEuyTM6jvLoH4BevyEyTE4lF13r4wEdFQTgz
         7BE6WgJFDeZt+ZfvXs+y6zbxm7gkd4glkM8iQ=
Message-ID: <3bc8237c0808301539v7b131b5fw4fa7a820170c3eae@mail.gmail.com>
Date: Sat, 30 Aug 2008 17:39:29 -0500
From: "Archie Cobbs" <archie@dellroad.org>
To: "Tejun Heo" <tj@kernel.org>
Subject: Re: [fuse-devel] [PATCHSET] CUSE: implement CUSE
Cc: "Mike Hommey" <mh@glandium.org>, fuse-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org, miklos@szeredi.hu
In-Reply-To: <48B93D68.6040506@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219947544-666-1-git-send-email-tj@kernel.org>
	 <20080829055000.GB18930@glandium.org> <48B78EBA.609@kernel.org>
	 <3bc8237c0808291150t2f18ba64vf445bdf4c2c8360c@mail.gmail.com>
	 <48B93D68.6040506@kernel.org>
X-Google-Sender-Auth: 82e80aae2016248a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 7:30 AM, Tejun Heo <tj@kernel.org> wrote:
> Yeah, compared to loopback over FUSE, anything would have less
> problem. :-) I don't know much about nbd but it's pretty much solving
> the same problem so I think it's logical to extend nbd including
> giving it a new transport if necessary?  Or is there something
> fundamentally better when it's done via FUSE?

Well, NBD is the bird in hand, but that doesn't mean it's the best way
to do things generically for all block device emulation applications.

I'd even argue that NBD should be removed from the kernel and replaced
by BUSE plus a user-land daemon. A BUSE interface could be a lot more
general, and simpler.

Not to mention that converting all block reads and writes to TCP
operations that talk to another process on the same machine via the
loopback interface seems awfully inefficient.

-Archie

--
Archie L. Cobbs
