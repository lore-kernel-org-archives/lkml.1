Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbZIAQki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbZIAQki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 12:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZIAQkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 12:40:37 -0400
Received: from mail-px0-f204.google.com ([209.85.216.204]:36231 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZIAQkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 12:40:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=eJD4Rt4WqwNPmTj16t6eG8a2mC7FbmVtBbhNNJh+zUy55HDl6BZRWb02hgCTqCnoF/
         N3LtqkugamEXMxsdr8+fRl8qRJIfXGs6fCsBCwdL6r8IQTYXP79s1vSPTssAlrlPJgqc
         P8zSpJf57+NVUR7Ot4/czvj0VQxxHq/OhZamA=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 1/1] introduce __cancel_delayed_work()
Date: Tue, 1 Sep 2009 09:40:33 -0700
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8; KDE/4.3.0; x86_64; ; )
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
References: <adazl9uw3w1.fsf@cisco.com> <20090828180015.GB19326@redhat.com> <ada1vmqpry7.fsf@cisco.com>
In-Reply-To: <ada1vmqpry7.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <20090901171316.41FAB526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 September 2009 09:09:36 am Roland Dreier wrote:
> 
>  > cancel_delayed_work() has to use del_timer_sync() to guarantee the
>  > timer function is not running after return. But most users doesn't
>  > actually need this, and del_timer_sync() has problems: it is not
>  > useable from interrupt, and it depends on every lock which could
>  > be taken from irq.
>  > 
>  > Introduce __cancel_delayed_work() which calls del_timer() instead.
>  > 
>  > The immediate reason for this patch is
>  > http://bugzilla.kernel.org/show_bug.cgi?id=13757
>  > but hopefully this helper makes sense anyway.
> 
> Thanks, Oleg!
> 
> Andrew -- how do you want to handle this?  This seems to be useful for
> the bug with IB that Oleg linked to, as well as by Dmitry in input, so
> I'm not sure what the best way to merge all this into 2.6.32 is.
> 
> I could take Oleg's patch and the corresponding fix to
> drivers/infiniband through my tree, and merge as early I as I see Linus
> open 2.6.32.  That leaves Dmitry to wait on it (and possibly causes
> problems in -next with tree ordering) though.  But I don't see any way
> to get the number of cross-tree dependencies below 1... (unless maybe
> Dmitry can take the identical workqueue patch into his tree and trust
> git to sort it out?)

I wonder if Linus would not just take it in 31 - it is a completely
new function with no current users (but users will surely follow) so
introducing regression is highly unlikely... That would resolve all
inter-tree dependencies.

Otherwise we'll have to leave our fate in the hands of git ;)

-- 
Dmitry
