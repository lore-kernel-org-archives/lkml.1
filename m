Return-Path: <linux-kernel-owner+w=401wt.eu-S1030540AbXAYTyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030540AbXAYTyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 14:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030542AbXAYTyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 14:54:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:44533 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030540AbXAYTyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 14:54:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=KqLNE7jlxlnSpff6IO9JWoRxCzY2oeuCfgGcmFQdNymbqcEbmRNP/E0iUfk8AH1SbOrL9+zrI3jvDv4wUqXx2krM3iHxwfBcVIBzfWKbeaTqzYMJ/Ch+xckjDaq2P8/cVKRk5zVEPqcv7SDgZvJdQf6hm70mLEqjff3lbCtgCYI=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: O_DIRECT question
Date: Thu, 25 Jan 2007 20:52:38 +0100
User-Agent: KMail/1.8.2
Cc: Michael Tokarev <mjt@tls.msk.ru>, Linus Torvalds <torvalds@osdl.org>,
       Viktor <vvp01@inbox.ru>, Aubrey <aubreylee@gmail.com>,
       Hua Zhong <hzhong@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, hch@infradead.org, kenneth.w.chen@in
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701251838.30796.vda.linux@googlemail.com> <45B904CF.1070102@cfl.rr.com>
In-Reply-To: <45B904CF.1070102@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701252052.38119.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 January 2007 20:28, Phillip Susi wrote:
> > Ahhh shit, are you saying that fdatasync will wait until writes
> > *by all other processes* to thios file will hit the disk?
> > Is that thue?
> 
> I think all processes yes, but certainly all writes to this file by this 
> process.  That means you have to sync for every write, which means you 
> block.  Blocking stalls the pipeline.

I dont understand you here. Suppose fdatasync() is "do not return until
all cached writes to this file *done by current process* hit the disk
(i.e. cached write data from other concurrent processes is not waited for),
report succes or error code". Then

write(fd_O_DIRECT, buf, sz) - will wait until buf's data hit the disk

write(fd, buf, sz) - potentially will return sooner, but
fdatasync(fd) - will wait until buf's data hit the disk

Looks same to me.

> > If you opened a file and are doing only O_DIRECT writes, you
> > *always* have your written data flushed, by each write().
> > How is it different from writes done using
> > "normal" write() + fdatasync() pairs?
> 
> Because you can do writes async, but not fdatasync ( unless there is an 
> async version I don't know about ).

You mean "You can use aio_write" ?
--
vda
