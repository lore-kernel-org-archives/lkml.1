Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbZCBRvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbZCBRvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 12:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbZCBRve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 12:51:34 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:45248 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbZCBRvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 12:51:33 -0500
Date: Mon, 2 Mar 2009 18:51:25 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: tom.leiming@gmail.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] driver core: implement uevent suppress in kobject(v1)
Message-ID: <20090302185125.5038a705@gondolin>
In-Reply-To: <1235913049-4533-1-git-send-email-tom.leiming@gmail.com>
References: <1235834729-14402-1-git-send-email-tom.leiming@gmail.com>
	<1235913049-4533-1-git-send-email-tom.leiming@gmail.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  1 Mar 2009 21:10:49 +0800,
tom.leiming@gmail.com wrote:

> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch implements uevent suppress in kobject and removes it
> from struct device, based on the following ideas:
> 
> 1,Uevent sending should be one attribute of kobject, so suppressing it
> in kobject layer is more natural than in device layer. By this way,
> we can do it for other objects embedded with kobject.
> 
> 2,It may save several bytes for each instance of struct device.(On my
> omap3(32bit ARM) based box, can save 8bytes per device object)
> 
> This patch also introduces dev_set|get_uevent_suppress() helpers to
> set and query uevent_suppress attribute in case to help kobject
> as private part of struct device in future.

But moving the kobject into an allocated private structure would be
rather broken?

I have no objections to the patch, though, and it worked fine on my
s390 LPAR.

> 
> [This version is against the latest driver-core patch set of Greg,please
> ignore the last version.]
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
