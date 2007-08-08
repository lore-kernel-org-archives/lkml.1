Return-Path: <linux-kernel-owner+w=401wt.eu-S1761470AbXHHIFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470AbXHHIFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 04:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbXHHIFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 04:05:20 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:6166 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbXHHIFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 04:05:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BsZqBTNZGTWwfk114COXiwsBfM+LtVCwtttu9MlGhs2jySu4gRUUhH5SCnVkDK4Jkfow4BirUPfKquy+t3HzulluU1X+yYD0heTtobErQsVa9TZ+VKphIWRj5itCZUzErigei6HN0ItvJ1oamRcmGy9e7GqlRzf03c6grmGOOM0=
Message-ID: <86802c440708080105i637f425bhe5c852efa8c3c1a9@mail.gmail.com>
Date: Wed, 8 Aug 2007 01:05:15 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Muli Ben-Yehuda" <muli@il.ibm.com>
Subject: Re: [PATCH 1/5] x86_64: get mp_bus_to_node as early v3
Cc: akpm@linux-foundation.org, ak@suse.de, apw@shadowen.org, clameter@sgi.com,
       greg@kroah.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070808072351.GK3383@rhun.haifa.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708072245.l77MjVxU008742@imap1.linux-foundation.org>
	 <200708071820.33720.yinghai.lu@sun.com>
	 <20070808072351.GK3383@rhun.haifa.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Muli Ben-Yehuda <muli@il.ibm.com> wrote:
>
> Can you explain why this patch (and your other patches in this area)
> are needed? is this a performance issue? the patches seem complex, is
> there a good argument for that complexity?
>
1. AMD K8 system with two HT chain: when acpi=off or there is not _PXM
in DSDT, still make numa_node of device get correct value. ...
/sys/devices/pci0000:80/*/numa_node will be correct instead of 0 for
all. ---- so far i didn't find one two chain AMD k8 based system have
_PXM in DSDT...
2. could use dev_to_node instead of pcibus_to_node.
3. complex? I don't think so. It just try to get bus_to_node mapping
from pci conf space and put into one 256 byte array early, and then
use it some link pxm_to_node.
4. make it support quad core opteron by change to scan four regs in NB
func1 intead of func0.

YH
