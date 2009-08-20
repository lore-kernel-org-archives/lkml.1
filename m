Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbZHTQjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbZHTQjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 12:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbZHTQjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 12:39:06 -0400
Received: from claw.goop.org ([74.207.240.146]:36661 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbZHTQjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 12:39:04 -0400
Message-ID: <4A8D7C26.5020902@goop.org>
Date: Thu, 20 Aug 2009 09:39:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Miroslav Rezanina <mrezanin@redhat.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Gianluca Guida <gianluca.guida@citrix.com>
Subject: Re: [PATCH][v2.6.29][XEN] Return unused memory to hypervisor
References: <2039875032.3531250754474167.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <2039875032.3531250754474167.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/09 00:47, Miroslav Rezanina wrote:
> there is handled e820 map in guest. However, this patch informs 
> hypervisor, that guest uses less memory than was assigned to it. 
> If hypervisor is not informed, memory is reserved for guest that
> do not need it. If hypervisor is informed, he decrease memory
> reservation for guest and unused memory is marked as free 
> for use by other guests.
>   

Yes.  But the guest will modify its own e820 map for a number of
reasons; for example: reducing its own memory, or clearing a space for
the PCI hole.  In general we want to free any underlying pages which
don't correspond to E820_RAM regions.

    J
