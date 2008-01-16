Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbYAPEmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbYAPEmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 23:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbYAPElw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 23:41:52 -0500
Received: from nz-out-0506.google.com ([64.233.162.234]:3404 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbYAPElv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 23:41:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LuTreOBXWMtc722s3NyLlDdHB93ra16xZmDoVzblqKXZLisFZlK5XFBHQe+MgSg4jHui1p0ORHunyWI9i38Nwyq+dOoOhJ0AmJJeWfR7lhLuGyTEltH4IUmTA6mYTND4INIhCJjAtjuWUIHe/A0j99fGzdhZAUt/CmNmkAl2EJQ=
Message-ID: <a8e1da0801152041m7f6ca5casf5a5a4147be7f65f@mail.gmail.com>
Date: Wed, 16 Jan 2008 12:41:50 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH for 2.6.24] fix workqueue creation API lockdep interaction
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Oleg Nesterov" <oleg@tv-sign.ru>
In-Reply-To: <1200402272.5887.140.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0801140104m2d8dceaayd8cf85466659bbf@mail.gmail.com>
	 <1200302644.7415.6.camel@twins>
	 <1200306902.5887.39.camel@johannes.berg>
	 <1200307288.7415.11.camel@twins>
	 <1200307896.5887.42.camel@johannes.berg>
	 <1200393685.5887.113.camel@johannes.berg>
	 <1200399661.26045.13.camel@twins>
	 <1200400787.5887.129.camel@johannes.berg>
	 <1200401245.26045.19.camel@twins>
	 <1200402272.5887.140.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 15, 2008 9:04 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Dave Young reported warnings from lockdep that the workqueue API
> can sometimes try to register lockdep classes with the same key
> but different names. This is not permitted in lockdep.
>
> Unfortunately, I was unaware of that restriction when I wrote
> the code to debug workqueue problems with lockdep and used the
> workqueue name as the lockdep class name. This can obviously
> lead to the problem if the workqueue name is dynamic.
>
> This patch solves the problem by always using a constant name
> for the workqueue's lockdep class, namely either the constant
> name that was passed in or a string consisting of the variable
> name.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Please be careful with this patch, I haven't been able to test it so far
> because my powerbook doesn't have lockdep.

Hi,
Just for confirm, the warnings didn't trigger after applied your patch, thanks.

Regards
dave
