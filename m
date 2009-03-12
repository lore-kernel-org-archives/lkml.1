Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbZCLRKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbZCLRKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 13:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbZCLRKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 13:10:07 -0400
Received: from mail-qy0-f122.google.com ([209.85.221.122]:57204 "EHLO
	mail-qy0-f122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbZCLRKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 13:10:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=ojWYCtOoD+Z9L4nre5FsMsVG67SrnGIYL7Z3CpqLzAmtMlo521TYnA/Ew2ni4iV89o
         xox7+7aVPgcERcoquMiTG9S8IX3qVCzkPRMXg2tZBCcsISUjsTVQ+Bvz/XpSZ68M0IRj
         LZwha6mo7WqoaklXIQXhUzt3oEfU6zsNHxjNo=
MIME-Version: 1.0
Reply-To: petkovbb@gmail.com
In-Reply-To: <200903121758.56808.bzolnier@gmail.com>
References: <1236158216-23052-1-git-send-email-petkovbb@gmail.com>
	 <200903111734.28956.bzolnier@gmail.com>
	 <20090312071248.GA26881@liondog.tnic>
	 <200903121758.56808.bzolnier@gmail.com>
Date: Thu, 12 Mar 2009 18:10:02 +0100
Message-ID: <9ea470500903121010y26ced87ck9f11a60f7b91a06b@mail.gmail.com>
Subject: Re: [PATCH 3/3] ide-{cd,floppy}: do not map all cmds to an sg
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Ah I see it now but this is a separate issue from the original one
> (OOPS on DEBUG_VIRTUAL=y)!

Hmm, no, this oopses on the same DEBUG_VIRTUAL check due to rq->data being NULL,
it is the same issue happening when entered from a different path:

> I somehow missed it (probably becasue
> patch description fails to mention this important information)
> and thus tried to be smart while merging the patch...

... and yes, we could add something along the lines of "Make sure ->data pointer
in sg mapping is set from all command issuing paths" to the commit message. My
bad, I'm being too economical wrt commit messages, as always :).

-- 
Regards/Gruss,
Boris
