Return-Path: <linux-kernel-owner+w=401wt.eu-S932208AbZHJQ30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbZHJQ30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932109AbZHJQ3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:29:25 -0400
Received: from outbound-mail-138.bluehost.com ([67.222.39.28]:35634 "HELO
	outbound-mail-138.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932193AbZHJQ3X convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:29:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ZzL5YT0JflSp+YhNQLU1XBZs8qVVh1NGrJLhb4IFpChTNXneoh8nWULB33ZkqWKncY53BcJO9W8nZTSuBkHSYhkevSZK+32jhkeczYao+liCvTqDnIgaEO7kXr/FaezS;
Date: Mon, 10 Aug 2009 09:29:21 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] pci/intr_remapping: Allocate irq_iommu on node
Message-ID: <20090810092921.48c3123f@jbarnes-g45>
In-Reply-To: <20090809104400.GA1087@elte.hu>
References: <4A785C17.3030104@kernel.org>
	<tip-94fb9a6b49d3a63831c4e752f6f0ab8da0a99eb5@git.kernel.org>
	<20090809104400.GA1087@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Aug 2009 12:44:00 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * tip-bot for Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > Commit-ID:  94fb9a6b49d3a63831c4e752f6f0ab8da0a99eb5
> > Gitweb:
> > http://git.kernel.org/tip/94fb9a6b49d3a63831c4e752f6f0ab8da0a99eb5
> > Author:     Yinghai Lu <yinghai@kernel.org> AuthorDate: Tue, 4 Aug
> > 2009 09:04:39 -0700 Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sat, 8 Aug 2009 17:07:37 +0200
> > 
> > pci/intr_remapping: Allocate irq_iommu on node
> 
> -tip testing found that this patch broke the x86 build:
> 
> drivers/pci/intr_remapping.c: In function ‘alloc_irte’:
> drivers/pci/intr_remapping.c:204: error: ‘struct irq_desc’ has no
> member named ‘node’ drivers/pci/intr_remapping.c: In function
> ‘set_irte_irq’: drivers/pci/intr_remapping.c:258: error: ‘struct
> irq_desc’ has no member named ‘node’

Looks like we need a wrapper function for this with proper CONFIG_NUMA
checks...  I'll apply it to my linux-next tree when someone sends me a
new version.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
