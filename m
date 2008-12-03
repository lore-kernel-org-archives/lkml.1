Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYLCAFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYLCAFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYLCAFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:05:13 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:51458 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbYLCAFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:05:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=csT/vXBqUFRFBcUdY3Wh/aD711TUMOUmHGo8mRi7lrSKUspWgmPZlIBgAkjRyVr+ZJ
         8LVHCN+oFgv8R9TQvurfL9I6nOrOnHAnfVl56eDmXwnf5WJDPntEfdd6WGnH+1lvll2d
         hI66xlD+fAMuSj2Uy+Vjzf/4Po+PkTXOO1qP4=
Message-ID: <4eea36270812021605s58f27857pda48fa3c5542affa@mail.gmail.com>
Date: Tue, 2 Dec 2008 16:05:10 -0800
From: "Russell Miller" <duskglow@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: NFS directory listing hang on write.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all.  We're having some NFS problems here that I don't understand.

The arguments are standard.  wsize=32768,rsize=32768,tcp.  Nothing
else out of the ordinary.  Test case is easy too:

mount a filesystem.
cd into the directory.
create a 1G file and background the creation, so 1G is being written
into the directory.
Then, try to ls the directory.

The ls will hang, sometimes for a few seconds, sometimes for the
entire length of the write.  This happens on every NFS server I've
tried, including an acopia, bluearc, onstor, and a generic linux box
running on the other end.

I have seen this behavior on multiple systems and using multiple
kernels.  Starting with the latest centos 5.2 kernel, but I've also
reproduced it on the stock 2.6.27.7.  I don't really understand what's
going on, but I think it has something to do with the attribute cache,
as setting actimeo=1 seems to have a positive effect.  Setting it to
zero seems to have no effect.

It does not seem to be happening with centos 4.x kernels, which are
based on 2.6.9.

I have turned on nfs and rpc debugging, and it's not telling me
anything useful, which is what I would expect if the attribute cache
is borking somehow.  I don't think there's any debugging for the cache
itself.

Can someone please give me an idea of how to proceed in debugging
this?  I'm not a stranger to the kernel, but this is deeper in than
I've gone before, and I am frankly a little over my head here.

Thanks,
