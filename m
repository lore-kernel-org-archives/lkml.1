Return-Path: <linux-kernel-owner+w=401wt.eu-S1761242AbXLMM4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761242AbXLMM4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 07:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbXLMM4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 07:56:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59912 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbXLMM4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 07:56:07 -0500
Date: Thu, 13 Dec 2007 13:55:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>,
       Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, kay.sievers@vrfy.org,
       Balbir Singh <balbir@in.ibm.com>, maneesh@in.ibm.com
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-ID: <20071213125509.GA28340@elte.hu>
References: <F1D642E5A91BC94D9504EC83AE19E6B0015201EF@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071211182015.GA22339@linux.vnet.ibm.com> <20071211182528.GA5597@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201F1@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071211210653.GA6902@elte.hu> <20071212070816.GA31455@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201F6@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071212134158.GA5547@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B00152021F@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071213114336.GA5400@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213114336.GA5400@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> Could you please see if the following patch removes the oops due to 
> CFS sysfs files? (There might still be the other oops due to the 
> floppy sysfs files)
> 
> Ingo, could you please add this patch in your CFS backport to 2.6.22 
> and older kernels?

sure - i've updated the backport patches with this fix.

>  static void user_attr_init(struct subsys_attribute *sa, char *name, int mode)
>  {
> +	sa->attr.owner = NULL;
>  	sa->attr.name = name;

i'm wondering why doesnt this affect 2.6.23 and later? Does sysfs 
initialize the owner field to NULL automatically?

	Ingo
