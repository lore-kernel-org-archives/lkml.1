Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbYBES3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbYBES3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbYBES3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:29:33 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:26739 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbYBES3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:29:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=htsa+o3jtVZ+Cc6azZUo+iiNi8jjhLUC2OuEKqVPV0J2n8VLkIehzKEcTwe9hxdasoNIFEh/XgvIMf0uplt32gDvMhF+FQHUYDnktBgggVUAnA7TbOhhTumRm0eVpRZNOnBsdL3/b/KrBdm0G93z81/5DAXdxJoCdfQvMn/hnSM=
Message-ID: <c9e534200802051029u5d08cf6dm54866f769e362262@mail.gmail.com>
Date: Tue, 5 Feb 2008 10:29:28 -0800
From: "Glenn Griffin" <ggriffin.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] Add IPv6 support to TCP SYN cookies
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080205155558.GA23145@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47a79d64.16538c0a.5b6a.ffffb0fe@mx.google.com>
	 <20080205155558.GA23145@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Syncookies are discouraged these days. They disable too many
> valuable TCP features (window scaling, SACK) and even without them
> the kernel is usually strong enough to defend against syn floods
> and systems have much more memory than they used to be.
>
> So I don't think it makes much sense to add more code to it, sorry.

As you say the kernel is usually strong enough to defend against syn flood
attacks, but what about the situations where it isn't?  As valuable as the TCP
features are I would give them up if it means I'm able to connect to my sshd
port when I otherwise would be unable to.  While increased synq sizes, better
dropping algorithms, and minisocks are a great way to mitigate the attacks and
in most cases are enough, there are situations where syncookies are nice.

Regardless, I would say as long as ipv4 has syncookie support it will
accurately be viewed as a deficiency of ipv6 if it lacks support.  So perhaps
the discussion should be we whether all the other defenses are enough to
warrant the removal of syncookie support from ipv4.  That topic may bring in
more opinions.

> Besides you should really move it to the ipv6 module, right now the code
> would be always compiled in even for ipv4 only kernels.

That is correct.  I will gladly move it into it's own section within net/ipv6/.
Do you have any problem using the same CONFIG and sysctl variables as the ipv4
implementation?

Thanks

--Glenn
