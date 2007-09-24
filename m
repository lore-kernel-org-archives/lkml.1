Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbXIXX3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbXIXX3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 19:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbXIXX2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 19:28:54 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42106 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758656AbXIXX2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 19:28:53 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 24 Sep 2007 16:28:49 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: roel <12o3l@tiscali.nl>
cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       axboe@kernel.dk, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/2] Enable link power management for ata drivers
In-Reply-To: <46F84460.5090703@tiscali.nl>
Message-ID: <Pine.LNX.4.64.0709241624460.24423@alien.or.mcafeemobile.com>
References: <20070924215140.966161778@intel.com>
 <20070924151320.67f0c332.kristen.c.accardi@intel.com> <46F84460.5090703@tiscali.nl>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007, roel wrote:

> > +	if (!(ap->flags & ATA_FLAG_IPM) || !ata_dev_enabled(dev)) {
> 
> 	if (!((ap->flags & ATA_FLAG_IPM) && ata_dev_enabled(dev))) {

int foo(int i, int j) {
        
        return !(i & 8) || !j;
}

int moo(int i, int j) {
        
        return !((i & 8) && j);
}


gcc -O2 -S:


.globl foo
        .type   foo, @function
foo:
        shrl    $3, %edi
        xorl    $1, %edi
        testl   %esi, %esi
        sete    %al
        orl     %eax, %edi
        andl    $1, %edi
        movl    %edi, %eax
        ret
.globl moo
        .type   moo, @function
moo:
        shrl    $3, %edi
        xorl    $1, %edi
        testl   %esi, %esi
        sete    %al
        orl     %eax, %edi
        andl    $1, %edi
        movl    %edi, %eax
        ret



- Davide


