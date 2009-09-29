Return-Path: <linux-kernel-owner+w=401wt.eu-S1753013AbZI2LZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbZI2LZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 07:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZI2LZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 07:25:22 -0400
Received: from mail-pz0-f191.google.com ([209.85.222.191]:45402 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbZI2LZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 07:25:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=NrPE04+Wx0sSGDeS15tPXERtNEAoaBtkLFGPEB5J4Hey7XMct2aJLcCPGBiSj8O3A6
         Q2CWK7/E0crGKy5KmwQ3JjQqqfbZY+KAvOvutSuken4ZeGG9s0lXwxzzascg1KBWUP9X
         6b7SCUHkCqC2fBiwRgUFWlGRDupIbTt+eTKCk=
MIME-Version: 1.0
Date: Tue, 29 Sep 2009 16:55:24 +0530
Message-ID: <f22d86810909290425s46406fe5ib00bcfc9673f70df@mail.gmail.com>
Subject: GFP_NOWAIT and GFP_NOMEMALLOC
From: "Leonidas ." <leonidas137@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I am new here, I have googled/binged enough before posting this message,
in case of redundancy please point me to appropriate links/resources etc.

I want to kmalloc memory while holding spinlocks in process context, here I
can't use GFP_KERNEL flag since it can sleep. Using GFP_ATOMIC guarantees
that allocation will succeed by allocating from emergency pools if needed.
But I dont think, I need to use emergency pool and I want to limit my memory
consumption to ZONE_NORMAL without sleeping, my module is ready to handle
the allocation failure if any.


Something like,

ptr =  kmalloc(..., GFP_KERNEL | GFP_DONT_SLEEP );

if( !ptr ) {

 /*GFP_KERNEL failed, Use GFP_ATOMIC pool*/
 ptr =  kmalloc(..., GFP_ATOMIC );

}
/*Go ahead and do stuff*/

Is there any flag which fetches memory from GFP_KERNEL pool with a
guarantee that
it will not sleep?

Does GFP_NOWAIT | GFP_KERNEL guarantee that?

Is ( GFP_NOWAIT | GFP_KERNEL ) == ( GFP_ATOMIC - dont access emergency pools)?

I am a bit confused about GFP_NOWAIT and GFP_NOMEMALLOC, any pointers will be
helpful.

-Leo.
