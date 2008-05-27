Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbYE0T0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbYE0T0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 15:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbYE0T0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 15:26:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:34282 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693AbYE0T0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 15:26:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UtTJi9xOxqJx11WXSiniJ7PEllaCi1ENxBZXR4wkzU6lmyzIFT+mQJzEVoqEZHsEDMi7vA7hM1saWx4/tTLcKQhJ5u5N2VI0g7hIu5owoKoWh6U3gEuZTlh7UFc0I9FiRrOLLnCQ3ZAcjsFTI5WIdwzY2vTZNKws6590KFrb1VI=
Message-ID: <412bdbff0805271226t41fe55b0jd0b8e3c737f34734@mail.gmail.com>
Date: Tue, 27 May 2008 15:26:27 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [PATCH] video4linux: Push down the BKL
Cc: "Jonathan Corbet" <corbet@lwn.net>, "Alan Cox" <alan@redhat.com>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080527155942.7693c360@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080522223700.2f103a14@core> <20080526135951.7989516d@gaivota>
	 <20080526202317.GA12793@devserv.devel.redhat.com>
	 <20080526181027.1ff9c758@gaivota>
	 <20080526220154.GA15487@devserv.devel.redhat.com>
	 <20080527101039.1c0a3804@gaivota>
	 <20080527094144.1189826a@bike.lwn.net>
	 <20080527133100.6a9302fb@gaivota>
	 <20080527103755.1fd67ec1@bike.lwn.net>
	 <20080527155942.7693c360@gaivota>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mauro,

On Tue, May 27, 2008 at 2:59 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> For example, em28xx has already a lock at the operations that change values at
> "dev" struct, including open() method. However, since the lock is not called at
> get operations, it needs to be fixed. I would also change it from mutex to a
> read/write semaphore, since two (or more) get operations can safely happen in
> parallel.

Please bear in mind that we have not worked out the locking semantics
for hybrid tuner devices, and it's entirely possible that the get()
routines will need to switch the tuner mode, which would eliminate any
benefits of converting to a read/write semaphore.

I'm not sure yet exactly how that's going to work, but it's something
that might prompt you to defer converting it from a mutex until we
have that worked out.

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
