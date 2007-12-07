Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbXLGWBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbXLGWBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 17:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbXLGWBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 17:01:31 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59777 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbXLGWBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 17:01:30 -0500
Message-ID: <4759C2B2.9020906@linux.vnet.ibm.com>
Date: Sat, 08 Dec 2007 03:31:22 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, rsa@us.ibm.com, apw@shadowen.org,
       balbir@in.ibm.com
Subject: Re: 2.6.24-rc4-mm1 kobject changes broken with hvcs driver on powerpc
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <20071205141202.GB13189@linux.vnet.ibm.com> <47583D4F.2050707@linux.vnet.ibm.com> <20071206185006.GA21641@kroah.com> <47584672.8040201@linux.vnet.ibm.com> <20071206203118.GA28618@kroah.com> <1196985291.18388.19.camel@dyn9047017100.beaverton.ibm.com> <20071207003204.GA11947@kroah.com> <4758B7C2.8080806@linux.vnet.ibm.com> <20071207051459.GC496@kroah.com>
In-Reply-To: <20071207051459.GC496@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> How about running 2.6.24-rc4 with _only_ the patch to this driver to
> convert it to krefs?  Does that combination cause problems?
> 
> The patch is at:
> 	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver/kobject-convert-hvcs-to-use-kref-not-kobject.patch

This patch works fine with _changes_ on 2.6.24-rc4. I can confirm that
it's not a kref problem in that case. This patch still assumes that
kref_get() returns a value. This is no longer true. The kref_get() call
site needs to be changed.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
