Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbZKWHcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbZKWHcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 02:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZKWHcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 02:32:52 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:34444 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbZKWHcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 02:32:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VoIpT+/MxiUWbE8ts6VTAMHi2+OanM4O+QYEGXju7sjk/ihTqW398Ss3UBttNfVVwb
         tSmcF0btJh4Mi/yBFUPE0SdJpkhQRcta1wuiNpkfOzi8iRC6KG1Ub+CKCSn7kiTuMSVJ
         9ReHFZFGgYdjKfiNfnnxbd9p45WB4LfkzYA74=
MIME-Version: 1.0
In-Reply-To: <20091123064630.7385.30498.stgit@ppwaskie-hc2.jf.intel.com>
References: <20091123064630.7385.30498.stgit@ppwaskie-hc2.jf.intel.com>
Date: Mon, 23 Nov 2009 15:32:57 +0800
Message-ID: <2674af740911222332i65c0d066h79bf2c1ca1d5e4f0@mail.gmail.com>
Subject: Re: [PATCH] irq: Add node_affinity CPU masks for smarter irqbalance 
	hints
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Cc: linux-kernel@vger.kernel.org, arjan@linux.jf.intel.com,
       davem@davemloft.net, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 2:46 PM, Peter P Waskiewicz Jr
<peter.p.waskiewicz.jr@intel.com> wrote:
> This patchset adds a new CPU mask for SMP systems to the irq_desc
> struct.  It also exposes an API for underlying device drivers to
> assist irqbalance in making smarter decisions when balancing, especially
> in a NUMA environment.  For example, an ethernet driver with MSI-X may
> wish to limit the CPUs that an interrupt can be balanced within to
> stay on a single NUMA node.  Current irqbalance operation can move the
> interrupt off the node, resulting in cross-node memory accesses and
> locks.
>
> The API is a get/set API within the kernel, along with a /proc entry
> for the interrupt.
>
> Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> ---

1) I think you should consider CONFIG_CPUMASK_OFFSTACK which will affect
   node_affinity.
2) It seems like this patch can't work with SPARSE_IRQ.

Thanks,
Yong
