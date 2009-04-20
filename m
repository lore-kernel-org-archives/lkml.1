Return-Path: <linux-kernel-owner+w=401wt.eu-S1751785AbZDTIsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbZDTIsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 04:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZDTIsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 04:48:09 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:23789
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752714AbZDTIsI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 04:48:08 -0400
X-BigFish: VPS-48(zz1432R98dR4015M1805M179dR936fK9371Pzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KIE5RW-02-F1C-01
Date: Mon, 20 Apr 2009 10:47:47 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: derive nearby CPUs from device's instead of bus'
	NUMA information
Message-ID: <20090420084747.GA7286@alberich.amd.com>
References: <20090417100155.GE16198@alberich.amd.com> <20090417162115.GF8253@elte.hu> <86802c440904171226g520e3b67h7318ff0f80f1e782@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <86802c440904171226g520e3b67h7318ff0f80f1e782@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Apr 2009 08:47:57.0665 (UTC) FILETIME=[B40A1510:01C9C194]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 12:26:54PM -0700, Yinghai Lu wrote:
> On Fri, Apr 17, 2009 at 9:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > const struct cpumask * cpumask_of_pcidev(struct pci_dev *dev)
> > {
> >        if (dev->numa_node == -1)
> >                return cpumask_of_pcibus(to_pci_dev(dev)->bus);
> >
> >        return cpumask_of_node(dev_to_node(dev));
> > }
> >
> > ? This would work fine in all cases.

Yes, I think so. That's the general solution w/o additional
"ifdefing".

> you are right, dev_to_node(dev) could return -1 on 64bit, if there is
> no memory on that node.

Hmm, I thought just in the CONFIG_NUMA=n case -1 is returned.

During initialization the struct device's numa_node is set to -1 and
later on the information is inherited from the parent numa_node.

So what do I miss?


Thanks,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


