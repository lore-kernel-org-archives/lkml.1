Return-Path: <linux-kernel-owner+w=401wt.eu-S1757793AbZEFJeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbZEFJeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 05:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZEFJdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 05:33:54 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57442 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbZEFJdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 05:33:54 -0400
To: tj@kernel.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net
In-reply-to: <49F90941.2030405@kernel.org> (message from Tejun Heo on Thu, 30
	Apr 2009 11:13:21 +0900)
Subject: Re: [PATCHSET] CUSE: implement CUSE, take #3
References: <1239674094-30894-1-git-send-email-tj@kernel.org> <E1Lwanr-00041r-RP@pomaz-ex.szeredi.hu> <49EFB1A9.3060503@kernel.org> <E1LwvrC-00068P-5r@pomaz-ex.szeredi.hu> <49F043A4.2060700@kernel.org> <E1LypSa-0004fR-J1@pomaz-ex.szeredi.hu> <49F908A1.70207@kernel.org> <49F90941.2030405@kernel.org>
Message-Id: <E1M1dVf-00051D-JE@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 06 May 2009 11:33:51 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Tejun Heo wrote:
> Tejun Heo wrote:
> >> I'll post the updated libfuse patch as well.  Please let me know if
> >> you find anything wrong with the current patches.
> > 
> > Looks good to me.  Much prettier with two inits merged.
> 
> Oh... what happened to CUSE_INIT_DONE?

By moving the CUSE_INIT reply processing into the ->end() callback,
the device initialization becomes synchronous with the process writing
the message into the cuse device.

This means, that the process can simply wait for the write() on the
device to complete before proceeding.

I've updated the libfuse patch so it calls ->init_done() after sending
the CUSE_INIT reply.

Thanks,
Miklos
