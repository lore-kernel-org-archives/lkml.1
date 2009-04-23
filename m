Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbZDWPbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbZDWPbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZDWPay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:30:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:27351 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZDWPax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:30:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=veNUUe2jPpe16uQ2y2BGA5rcYq9TYTcCucngIGwLq/duG3DO74KKWYQpqrJWoo/Dsj
         eUqLRFs9zRXcVFqHWfuZ7XaVEpZYeRjqv81lH/GcqDffrsiSekKhW8qfkq7DBOdk00dC
         pU1Kgu3Njt17/VRQ4/Zsu/BIsS6OFL+4G/2xM=
MIME-Version: 1.0
In-Reply-To: <20090423125848.GB11519@jurassic.park.msu.ru>
References: <20090419090208.GA30211@elte.hu>
	 <20090420223305.GA15340@jurassic.park.msu.ru>
	 <49ED0EBC.4070901@kernel.org>
	 <20090421105629.GB17904@jurassic.park.msu.ru>
	 <49EF9C10.6090107@kernel.org> <20090422154900.08f8f366@hobbes>
	 <49EFBB0E.3030401@kernel.org> <20090422180505.2518e837@hobbes>
	 <86802c440904221903p5667bbf9y642d671942555958@mail.gmail.com>
	 <20090423125848.GB11519@jurassic.park.msu.ru>
Date: Thu, 23 Apr 2009 08:30:52 -0700
Message-ID: <86802c440904230830m2e978078s71953dcb23a059b8@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] pci: don't assume pref memio are 64bit -v3
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 5:58 AM, Ivan Kokshaysky
<ink@jurassic.park.msu.ru> wrote:
> On Wed, Apr 22, 2009 at 07:03:33PM -0700, Yinghai Lu wrote:
>> to check the BAR support 64bit or not should be read from
>> pci_read_bases and pci_bridge_read_bases...
>
> pci_read_bases: take a closer look at decode_bar() function and
> PCI_BASE_ADDRESS_MEM_TYPE_64 flag.
>
> pci_bridge_read_bases: we cannot rely on the bits 0-3 of
> PCI_PREF_MEMORY_BASE providing correct information anyway.
> More reliable check for 64-bitness would be a test for
> PCI_PREF_BASE_UPPER32 register being r/w, which I think
> belongs in pci_bridge_check_ranges().

check bits 0-3 and check PCI_PREF_BASE_UPPER32 register being r/w ?

YH
