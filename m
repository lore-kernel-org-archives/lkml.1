Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbZDJM1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbZDJM1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759660AbZDJM0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:26:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:29904 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632AbZDJM0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:26:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c8iclxoFlRE7oUFLmt6z6ztl2Uuz1KHLeemk5jc6ntLMkHCusjRVcSserGeay+bNQl
         10U9qUYv3h+4tlEZST47S+YizpUJxVSqkGNzhoZSLOqXPSj79tnE9W9R8uDDLptFOruL
         rMEpmPzprAitaof9kjQqEJHM21LBqCLdfEw+w=
MIME-Version: 1.0
In-Reply-To: <20090408133524.395437925@I-love.SAKURA.ne.jp>
References: <20090408133126.180521064@I-love.SAKURA.ne.jp>
	 <20090408133524.395437925@I-love.SAKURA.ne.jp>
Date: Fri, 10 Apr 2009 22:26:52 +1000
Message-ID: <e7d8f83e0904100526y38ba5cc1p905e7b19c0307525@mail.gmail.com>
Subject: Re: [TOMOYO 1/2] tomoyo: add Documentation/tomoyo.txt
From: Peter Dolding <oiaohm@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, Kentaro Takeda <takedakn@nttdata.co.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +We believe that inode based security and name based security are complementary
> +and both should be used together. But unfortunately, so far, we cannot enable
> +multiple LSM modules at the same time. We feel sorry that you have to give up
> +SELinux/SMACK/AppArmor etc. when you want to use TOMOYO.
> +
> +We hope that LSM becomes stackable in future. Meanwhile, you can use non-LSM
> +version of TOMOYO, available at http://tomoyo.sourceforge.jp/en/1.6.x/ .
> +LSM version of TOMOYO is a subset of non-LSM version of TOMOYO. We are planning
> +to port non-LSM version's functionalities to LSM versions.
>
If you go back through the mailing list you will find stackable has
been debated at length many times.

AppArmor and Tomoyo are both name based.  So unlikely you would want
both at the same time.

LSM exists mostly because designers of security systems could not
decide on the 1 default Linux should have.

For inode and name based security the question should be can Tomoyo
merge with the other LSM modules in away that avoids stacking.

Smack and Selinux are sharing code in places with each other.   Really
there are only 3 currently active developed LSM's Smack Selinux and
Tomoyo.  Merge could basically get us down to 1 with 3 different
configure processing engines.   I have not seen apparmor patches that
bring it up to using the secure way of doing name based secuirty.
Could have missed it.

Smack and Selinux both have not contained name based because there was
no secure way todo it.  Due to Tomoyo teams work that has changed.  So
both Smack and Selinux really need to look at there position on
supporting name based.  I agree it would be a gain of Smack and
Selinux supported name based.

Major reason for not allowing multi-able LSM's is the risk that one
might interfere incorrectly with the others operation.  This is why
merging is fine.  Since the new method would have to be integrated at
development time into 1 LSM  so there could not be conflits.

Peter Dolding
