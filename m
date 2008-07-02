Return-Path: <linux-kernel-owner+w=401wt.eu-S1761274AbYGBAEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761274AbYGBAEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 20:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757939AbYGBAEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 20:04:10 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:3643 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbYGBAEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 20:04:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=R4oVA7MNuOH1H3ptfJhw4O7kjAsn2VG94VHyzv1U9Zb8citxAn2W0jx2mfXWgW/pKC
         isiZMFaRstwluJjhHklmJjVNV7XY/mG4Rn063Pyn9hwDc6VzROJ+V1GxXkMqIR+6xmsV
         /2ke5u173MQ4fW8qcKnqGQi8QJLn0HywQFXIM=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 1/23] make section names compatible with -ffunction-sections -fdata-sections
Date: Wed, 2 Jul 2008 02:03:54 +0200
User-Agent: KMail/1.8.2
Cc: linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
References: <200807020233.48646.vda.linux@googlemail.com> <60320.1214952973@turing-police.cc.vt.edu>
In-Reply-To: <60320.1214952973@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807020203.54809.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 July 2008 00:56, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 02 Jul 2008 02:33:48 +0200, Denys Vlasenko said:
> 
> > The purpose of these patches is to make kernel buildable
> > with "gcc -ffunction-sections -fdata-sections".
> > 
> > Newer gcc and binutils can do dead code and data removal
> > at link time. It is achieved using combination of
> > -ffunction-sections -fdata-sections options for gcc and
> > --gc-sections for ld.
> 
> Interesting idea.  Do you happen to have before-and-after 'size vmlinux'
> numbers to show how much space is actually reclaimed?

After this patch there will be no change - it does not do
dead code and data removal. I submitted bigger change before
but it was probably too big for digestion.

That earlier version was achieving ~10% kernel size reduction
if kernel is built without loadable module support
(loadable modules interfere with linker's dead code
and data removal, need to add some rather contrived magic
to make it work there too. Left as TODO for later).
--
vda
