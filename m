Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbYIGEfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbYIGEfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 00:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYIGEfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 00:35:03 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:42930 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750766AbYIGEfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 00:35:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=m2kyY3xKJ71y58vT1qnAiA8s/7k6xjZlf6FmmNu4xUcrqe5YpyJyNDG6OnFd1HP2JDrLmf8GDVhTMxgJWOEfuwwhBbglQlf7Sz1EYlGEtMwwi4Rg3NZZY8h2GaVElUDMesKDuxGI2yPN+kJIPn/cozH8bhOz5JlWzuDtktEAVXk=  ;
X-YMail-OSG: o1lkmM4VM1k3SorhcvbzsK4d8vRBavrI0oti05ADF5khb7AeUXL.XvRoY6Q0LnWziwLihrb3c4mFnqEnztdnJppVos0wlft5a1uFZ0B..8ag7Fftr3BFAbSSzuJGYvAcw0s-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: g_file_storage: fix handling zero-length packet
Date: Sat, 6 Sep 2008 21:32:56 -0700
User-Agent: KMail/1.9.9
Cc: sangsu <sangsu@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, gregkh@suse.de
References: <Pine.LNX.4.44L0.0809061615340.30019-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0809061615340.30019-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809062132.56859.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 September 2008, Alan Stern wrote:
> Secondly, the patch is not needed.  g_file_storage doesn't have to 
> check whether the data size is a multiple of MaxPacketSize because the 
> device controller driver already is supposed to make that check.

Exactly.

The only fuzziness here is what to do if the host misbehaves and
sends another IN packet when all its data has been sent, instead
of the OUT/STATUS packet.  (Host error...)

Most peripheral controller hardware is well enough designed that
it can detect this and send a zero length packet rather than STALL
the transfer.  It's polite to do so, because that host bug isn't
exactly unknown.  (Some old versions of Linux did that...)
