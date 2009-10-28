Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbZJ1K1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbZJ1K1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 06:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbZJ1K1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 06:27:06 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55290 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbZJ1K1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 06:27:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=x5POOglQuO28effpZNA28/Fr+EMN/YLAB8yFhGcH5S98wr3HW2+73LdXDdwUSWm05S
         pIdNz/MPQ5JHUyfOqLdvDwnVnZMVxh6nvegKQcBafYvqv4um0CdjQW3hQswjaFDN7pCC
         boitiidDqLjenBLHqHXGDSQz+CU1zsbuoHDmM=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: is avoiding compat ioctls possible?
Date: Wed, 28 Oct 2009 11:27:04 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, airlied@gmail.com,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
References: <21d7e9970910271822p3751b2fdnd78e1bc3326b9b0b@mail.gmail.com> <20091027.203709.27104760.davem@davemloft.net> <20091028043611.GK7744@basil.fritz.box>
In-Reply-To: <20091028043611.GK7744@basil.fritz.box>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910281127.04755.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 October 2009, Andi Kleen wrote:
> > > However some architectures need special operations on compat pointers
> > > (s390 iirc), but if you don't support those it might be reasonable
> > > to not support that.
> > 
> > s390 has to sign extend all 32-bit compat process pointers when
> > processing them in the 64-bit s390 kernel.  I think one other
> > architecture has this kind of situation too.
> 
> Which other architure? I reviewed all the definitions in tree
> and don't see any other than s390 doing magic there.

I'm also pretty sure that s390 is the only one needing this, I
added the compat_ptr stuff initially.

Note that a cast from pointer to unsigned long to u64 and back
in C does the correct 31 to 64 bit extension, which btw is not
a sign-extend but a unsigned extend clearing the upper 33 bits.

The easier rule to remember should be to always to compat_ptr()
on any pointer coming from user space, and to avoid pointers in
data structures where possible, as DaveM pointed out.

	Arnd <><
