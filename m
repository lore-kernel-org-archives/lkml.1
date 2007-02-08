Return-Path: <linux-kernel-owner+w=401wt.eu-S1423036AbXBHOMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423036AbXBHOMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 09:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423038AbXBHOMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 09:12:13 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:33557 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423036AbXBHOML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 09:12:11 -0500
Subject: Re: Kbuild change breaks the ppc64 build
From: Michal Ostrowski <mostrows@watson.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, olecom@flower.upol.cz,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070208.040003.112623191.davem@davemloft.net>
References: <17867.1342.763881.188430@cargo.ozlabs.ibm.com>
	 <20070208.040003.112623191.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 08 Feb 2007 08:12:00 -0600
Message-Id: <1170943920.15584.234.camel@kdsk1.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Isn't the extra space there because you've included it in the definition
of "test"?  The attempt at introducing indentation introduces the extra
space character.  Defining test without the internal indentation should
produce the results you are looking for.


-- 
Michal Ostrowski <mostrows@watson.ibm.com>


On Thu, 2007-02-08 at 04:00 -0800, David Miller wrote:

> For some reason $(call ...) invocations add spaces.  I tried
> another test case:
> 
> define test
>  $(shell echo -n)
> endef
> 
> VAR:=$(call test)
> 
> all:
> 	@echo "\'$(VAR)\'"
> 
> And this always prints:
> 
> ' TEST'
> 
> even with GNU Make version 3.81
> 
> If I put a $(strip ...) around the define, the space is
> still there.  If I put the $(strip ...) around VAR's
> $(call), the space goes away.


