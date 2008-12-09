Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbYLIWZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbYLIWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbYLIWZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:25:50 -0500
Received: from outbound-mail-153.bluehost.com ([67.222.39.33]:45467 "HELO
	outbound-mail-153.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754496AbYLIWZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:25:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=uoTIcABsU2CSzWzUmIO3hUVZBx2DIL6/d2mKDIa+8kam5pHqjmuEXD4yRKR6RIT336qwDShw/S9eO9mpq4R3QGnwtvBC8niGBwHeA9Ddwixe2g1NLwOHsWV0yzgfqp5A;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
Date: Tue, 9 Dec 2008 14:25:24 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Mark McLoughlin <markmc@redhat.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       kvm <kvm@vger.kernel.org>, Anthony Liguori <aliguori@us.ibm.com>,
       Michael Tokarev <mjt@tls.msk.ru>
References: <1228394671.3732.77.camel@blaa> <200812051043.51417.rusty@rustcorp.com.au>
In-Reply-To: <200812051043.51417.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812091425.25569.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 216.239.45.19 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 04, 2008 4:13 pm Rusty Russell wrote:
> On Thursday 04 December 2008 23:14:31 Mark McLoughlin wrote:
> > Nothing takes a ref on virtio_pci, so even if you have
> > devices in use, rmmod will attempt to unload the module.
> >
> > Fix by simply making each device take a ref on the module.
>
> Hi Mark,
>
>    Taking a reference to oneself is almost always wrong.  I'm a little
> surprised that a successful call to pci_device->probe doesn't bump the
> module count though.
>
> Jesse?

Looks like the PCI bus type's probe function does take a device reference, 
which should get called from driver_register when the driver calls 
pci_register_driver...  Is that not happening in the virtio case?

-- 
Jesse Barnes, Intel Open Source Technology Center
