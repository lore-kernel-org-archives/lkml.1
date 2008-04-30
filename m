Return-Path: <linux-kernel-owner+w=401wt.eu-S1761498AbYD3NwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761498AbYD3NwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 09:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbYD3Nvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 09:51:50 -0400
Received: from hu-out-0506.google.com ([72.14.214.232]:40537 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759918AbYD3Nvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 09:51:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XhRuVs3rHQZ8BZspIKteJoUW5ZVJDGHsefSQzS1sB+ZZroymNk12RmvrMfDcGSF3JT+iiK+wtUBQfFikjwXGXJ9p712WLxF5Ki6N2SvAHTej5yc2VIoRWldsS5xkuyMiT1/NXrhQNcgyG9apuyD32Wi9eQwVB3dRAtS+DkMoREQ=
Message-ID: <7c86c4470804300651u5a8fc98dr56fd1834ba902a0e@mail.gmail.com>
Date: Wed, 30 Apr 2008 15:51:39 +0200
From: "stephane eranian" <eranian@googlemail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: 2.6.25 new perfmon kernel patch + libpfm + pfmon available
Cc: linux-kernel@vger.kernel.org, ia64 <linux-ia64@vger.kernel.org>,
       "Robert Richter" <robert.richter@amd.com>
In-Reply-To: <20080429083334.1a019318@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470804291446l4693b317ha7ee2382d00e99e6@mail.gmail.com>
	 <7c86c4470804291447w713934a7o2b8a5a690fc9a535@mail.gmail.com>
	 <20080429080853.48c66b29@infradead.org>
	 <7c86c4470804300611s7442fe11lba2b66f5a3a8ed88@mail.gmail.com>
	 <20080429083334.1a019318@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I recall, AMD said that this special initialization would eventually migrate
into the core kernel. The pci_read() may be there because it was not exported
by the kernel (this particular code lives in a kernel module).

If you think there is now enough support in the core kernel to do this
initialization
then I'd be happy to remove this piece of code.




On Tue, Apr 29, 2008 at 5:33 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Wed, 30 Apr 2008 15:11:11 +0200
>
> "stephane eranian" <eranian@googlemail.com> wrote:
>
>
> > Sorry,
>  >
>  > It's http://perfmon2.sf.net
>  >
>  >
>
>  hummmmm, I wonder why perfmon wants to reimplement half of the PCI layer...
>
>  +extern spinlock_t pci_config_lock;
>  +
>  +#define PCI_CONF1_ADDRESS(bus, devfn, reg) \
>  +       (0x80000000 | ((reg & 0xF00) << 16) | ((bus & 0xFF) << 16) \
>  +       | (devfn << 8) | (reg & 0xFC))
>  +
>  +#define is_ibs_pmc(x) (x == 4 || x == 5)
>  +
>  +static int pci_read(unsigned int seg, unsigned int bus,
>  +                   unsigned int devfn, int reg, int len, u32 *value)
>  +{
>  +       unsigned long flags;
>
>  especially since this doesn't seem to use the proper config space abstractions :(
>
