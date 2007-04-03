Return-Path: <linux-kernel-owner+w=401wt.eu-S966182AbXDCRby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966182AbXDCRby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966192AbXDCRby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:31:54 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43466 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966189AbXDCRbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:31:53 -0400
Date: Tue, 3 Apr 2007 20:31:51 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Rene Herman <rene.herman@gmail.com>
cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
In-Reply-To: <Pine.LNX.4.64.0704031723580.3355@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0704032030470.8078@sbz-30.cs.Helsinki.FI>
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk>
 <460EA727.8070306@gmail.com> <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com>
 <4610481D.8000102@gmail.com> <46104954.50608@gmail.com>
 <Pine.LNX.4.64.0704020949160.23099@sbz-30.cs.Helsinki.FI>
 <20070402071018.GE11996@kernel.dk> <Pine.LNX.4.64.0704021152280.27165@sbz-30.cs.Helsinki.FI>
 <46111ED7.20201@gmail.com> <Pine.LNX.4.64.0704021837480.6518@sbz-30.cs.Helsinki.FI>
 <46112650.8080208@gmail.com> <Pine.LNX.4.64.0704021906040.7500@sbz-30.cs.Helsinki.FI>
 <461165FD.2010508@gmail.com> <Pine.LNX.4.64.0704030908420.20080@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0704030956330.20741@sbz-30.cs.Helsinki.FI> <461256C1.4020906@gmail.com>
 <Pine.LNX.4.64.0704031723580.3355@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Pekka J Enberg wrote:
> However, we never hit do_mcdx_request(). Jens, do we need to do 
> set_capacity() somewhere? I don't see other cdrom drivers doing it but 
> they could be broken too...

Oh, well, here goes. Rene, would you be so kind and spin the wheel once 
more? =)

				Pekka

diff --git a/drivers/cdrom/mcdx.c b/drivers/cdrom/mcdx.c
index f574962..8ed61c9 100644
--- a/drivers/cdrom/mcdx.c
+++ b/drivers/cdrom/mcdx.c
@@ -672,6 +672,7 @@ static int mcdx_open(struct cdrom_device
 		if (-1 == mcdx_requesttocdata(stuffp, &stuffp->di, 1)) {
 
 			stuffp->lastsector = -1;
+			set_capacity(stuffp->disk, 0);
 
 		} else {
 
@@ -692,6 +693,7 @@ static int mcdx_open(struct cdrom_device
 			       stuffp->di.msf_leadout.second,
 			       stuffp->di.msf_leadout.frame,
 			       msf2log(&stuffp->di.msf_leadout));
+			set_capacity(stuffp->disk, stuffp->lastsector + 1);
 		}
 
 		if (stuffp->toc) {
