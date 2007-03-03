Return-Path: <linux-kernel-owner+w=401wt.eu-S2992959AbXCCDLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992959AbXCCDLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 22:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992963AbXCCDLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 22:11:10 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:57367 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992959AbXCCDLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 22:11:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=facAcO8vIall3LMQMg0wQGf+Czyn5gkwMYVmb2Ppzwo7wkdB1sB4GJFH8AfESVy4B6njSWrILy4baSIGLFMOnKTC1mK+viJqjjwuwl1ImHPb8svwxieZRlD3QeB/Lh9wFRMOp8nrg+QY3XKbrgXzuxK1Ez8UhR2glb3T1zIizpk=
Message-ID: <45E8E749.4030406@gmail.com>
Date: Sat, 03 Mar 2007 12:11:05 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-ide@vger.kernel.org, Alan <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] libata: add missing PM callbacks
References: <20070302083001.GK20322@htj.dyndns.org> <45E8B3C8.2090009@garzik.org>
In-Reply-To: <45E8B3C8.2090009@garzik.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing Pavel and linux-kernel, hello]

Original thread can be read from

  http://thread.gmane.org/gmane.linux.ide/16475

Jeff Garzik wrote:
> Tejun Heo wrote:
>> Some LLDs were missing scsi device PM callbacks while having host/port
>> suspend support.  Add missing ones.
>>
>> Signed-off-by: Tejun Heo <htejun@gmail.com>
> 
> applied 1-3, though I agree with Alan that a non-ifdef solution should
> be sought (by the PM & PCI people?), where possible

Agreed, CONFIG_PM ifdefs are all over low level drivers, libata or not,
and ugly as hell.  Maybe use separate section, mark functions with
__power and drop them at link time is a better idea.  With linker
tricks, we can make references to __power symbols NULL.  How does it sound?

-- 
tejun
