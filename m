Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbYKYHWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbYKYHWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 02:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYKYHWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 02:22:05 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:25490 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbYKYHWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 02:22:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=no4J3b+a/ffcdBMF6sS9cLdGiRbVH2D1EYkuPClg9gEX3HPKGEvSC6H6rQgx3l6G1J
         P3OrVjIqoTonQs01QiZURYTth3eF40Wm8n0W5NXYFoMcbC8Y/Ha7sXY0igeL0Lj7Vd1Y
         20ujOsqsSdkZAJ6OltqUcwYGEZLzBHbYx9Rnk=
Date: Tue, 25 Nov 2008 08:21:56 +0100
To: Mel Gorman <mel@csn.ul.ie>
Cc: bzolnier@gmail.com, sshtylyov@ru.mvista.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: Is the change to IDE probing really necessary?
Message-ID: <20081125072156.GA3771@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Mel Gorman <mel@csn.ul.ie>,
	bzolnier@gmail.com, sshtylyov@ru.mvista.com,
	alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <20081124155632.GE23190@csn.ul.ie> <20081124225139.GA26953@gollum.tnic> <20081125000102.GC8293@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125000102.GC8293@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[.. ]

> > And the probing _is_ done when loaded as a module so the problem is
> > not with the mask - in your case the probing will work just fine as
> > you need ide0 and ide1, AFAICT.
> 
> Out of curiousity, I loaded ide-generic as a module and tried the suggested
> probe_mask. It loads after e100 which is built in and then has a crap attack
> as it tries to register IO regions which are already registered, triggers
> sysfs warnings for creating duplicate files and then continues along to
> a state where networking doesn't work anyway. That suggestion of 0x3f may
> still catch someone.

Yep, the message could be misleading wrt to the probe_mask. Is something
along the lines of

"please adjust the probe_mask module parameter for probing the rest of the
legacy ISA IDE ports"

more informative? Now it implies that the primary/secondary ports are
probed by default.

However, you still have to set it to something > 0x3 if you want to
probe ide[2-5]. Also, there's still the option of CONFIG_BLK_DEV_GENERIC
which adds support for otherwise unsupported IDE PCI controllers.

-- 
Regards/Gruss,
    Boris.
