Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbZJPIuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbZJPIuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 04:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbZJPIuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 04:50:00 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:48979 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbZJPIt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 04:49:59 -0400
Date: Fri, 16 Oct 2009 10:49:24 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, linuxppc-dev@ozlabs.org,
       brueckner@linux.vnet.ibm.com, Timur Tabi <timur@freescale.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hvc_console: returning 0 from put_chars is not an error
Message-ID: <20091016084924.GB4234@linux.vnet.ibm.com>
Mail-Followup-To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
	Scott Wood <scottwood@freescale.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	linuxppc-dev@ozlabs.org, Timur Tabi <timur@freescale.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1255557226-4403-1-git-send-email-timur@freescale.com> <200910152041.26646.borntraeger@de.ibm.com> <4AD770A9.6070509@freescale.com> <200910152126.28024.borntraeger@de.ibm.com> <4AD778E6.7020806@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD778E6.7020806@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 02:32:54PM -0500, Scott Wood wrote:
> Christian Borntraeger wrote:
>> About the backends, there are some that spin until the text is 
>> delivered (e.g. virtio) , others can drop (e.g. iucv is a connection 
>> oriented protocol and it will (and has to) drop if there is no 
>> connection). 
>
> Sure, dropping due to not having a connection makes sense.  That's  
> different from merely being busy.  Can the iucv code tell the difference  
> between those two states?

The states are handled by the hvc_iucv itself:
If the hvc_iucv code has a connection established, terminal or console data
are queued and sent to the peer. If the state is disconnected, terminal and
console data is discarded internally.

- Hendrik
