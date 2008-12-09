Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbYLIXAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbYLIXAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbYLIXAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:00:17 -0500
Received: from outbound-mail-304.bluehost.com ([67.222.53.250]:42249 "HELO
	outbound-mail-304.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754871AbYLIXAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:00:15 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2008 18:00:15 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=ZKEI6Q+TyySkeVnTovI6D2ywN5c0k/SiI1sOgVRqYOZO3ywWzY2VnsrcrcDcBw6PYpw8dWYhuwqQk4clQXiUY1kFUtEJEXol7l4rT9XRWqPC0VAS5bZrPgayS5+0JPFM;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/1] work_on_cpu: use in drivers/pci/pci-driver.c
Date: Tue, 9 Dec 2008 14:52:48 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200812011850.42203.rusty@rustcorp.com.au>
In-Reply-To: <200812011850.42203.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812091452.48824.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 216.239.45.19 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 01, 2008 12:20 am Rusty Russell wrote:
> This uses work_on_cpu(), rather than altering the cpumask of the
> thread which we happen to be.
>
> Note the cleanups:
>
> 1) I've removed the CONFIG_NUMA test, since dev_to_node() returns -1
>    for !CONFIG_NUMA anyway and the compiler will eliminate it.
>
> 2) No need to reset mempolicy to default (a bad idea anyway) since
>    work_on_cpu is run from a workqueue.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>

Nice, I applied this to my linux-next branch to get some build/test coverage.  
Please cc linux-pci in the future though.

-- 
Jesse Barnes, Intel Open Source Technology Center
