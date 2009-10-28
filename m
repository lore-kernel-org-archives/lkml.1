Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbZJ1PkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbZJ1PkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 11:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbZJ1PkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 11:40:20 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37025 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbZJ1PkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 11:40:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=XD/Na1e536g/Ez0tLfFHnXyCxwu3Th0TZfi3akDrOfaP/musFK6apiVaDv/uGgcOdT
         Iss2MFKn1VR/OX9d5SN/dSDKQzXnqb+eKV8pU6UaxqpYxBZt+pdQ6B/5aMox++l4pcCI
         C83R/FRxeAqzo2AEI5gjMzFQkaLTOstWdAICo=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: is avoiding compat ioctls possible?
Date: Wed, 28 Oct 2009 16:40:18 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: arndbergmann@googlemail.com, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, andi@firstfloor.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20091027.230450.222178419.davem@davemloft.net> <200910281313.32827.arnd@arndb.de> <20091028.051631.212225494.davem@davemloft.net>
In-Reply-To: <20091028.051631.212225494.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910281640.18491.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 October 2009, David Miller wrote:
> > The ioctl argument actually needs a compat_ptr() conversion as well.
> > For the s390 case, we can't do that in common code, because some
> > ioctl methods put a 32 bit integer into the argument. Not sure if we
> > want to fix that everywhere, the problem is very common and the
> > impact is minimal.
> 
> What does s390 do with the 'arg' argument to sys_ioctl()?

It clears the top 32 bits, but not bit 31, because that is significant
for a few ioctl handlers passing data directly instead of a pointer.
 
> That assumption that you can cast this to a pointer is everywhere.

Yes, I know :(

> If someone wants to fix this up, feel free to do an audit and go
> over that seperately from my work :-)

Cc'ing Heiko and Martin, since I'm not working on s390 any more.

I'm pretty sure it was ok when we started adding the compat_ioctl
handlers years ago. I think most people just ignored these for
the majority of drivers that can't possibly run on s390. Even
on s390, gcc will always do the right thing if you call call ioctl
with a pointer to a normal object in the .data section, heap or stack,
but hand-written assembly or other compilers may not.

	Arnd <><
