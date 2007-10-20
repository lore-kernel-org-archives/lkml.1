Return-Path: <linux-kernel-owner+w=401wt.eu-S932126AbXJTFxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbXJTFxA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 01:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbXJTFwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 01:52:53 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:43768 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752575AbXJTFwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 01:52:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=A3a5KfvRTYwNYEbPldOy2/2oSZR10jJiepjKLI/8VCdr93Nt9rG+y1rmYRza8MouemzxRhw6+EjIPc2Cg05dAitrYlhXx8Wul27zjV3axS7OzTIYVTeLeq+CgMe8yZOnhVN+RhzcXrHcGe9yDQvemCAd2Ef8WUZYYhKtj3Zefr0=  ;
X-YMail-OSG: 9tL5U_kVM1m3yFDsVP4PlFDcuOK_doObXsCFREZbT6JrBbkoLPBJU1T1Yblmhg02YhKSnfA_iQ--
Date: Fri, 19 Oct 2007 22:52:50 -0700
From: David Brownell <david-b@pacbell.net>
To: sam@ravnborg.org
Subject: Re: [patch 2.6.23-git] toplevel Makefile/depmod bugfix
Cc: linux-kernel@vger.kernel.org
References: <20071020044224.DD48423A6FC@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071020053642.GA4535@uranus.ravnborg.org>
In-Reply-To: <20071020053642.GA4535@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071020055251.1847823A75A@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > -	if [ -r System.map -a -x $(DEPMOD) -a "$(SUBARCH)" == "$(ARCH)" ]; then \
> > +	if [ -r System.map -a -x $(DEPMOD) -a "$(SUBARCH)" = "$(ARCH)" ]; then \
>
> Took a look at 'man bash' here.
> bash --version
> GNU bash, version 3.2.9(1)-release (x86_64-redhat-linux-gnu)
> Copyright (C) 2005 Free Software Foundation, Inc.
>
> Accoding to man bash "==" is used to test for equality and "=" is used for assignmnet.

"man test" shows that only "=" works ... that's for string equality,
which is what's being tested there.  And "==" is undefined (error).

If "==" were to kick in that would be for an arithmetic expression;
but "[" is (modulo wierdness) "test" not "expr".


> I assume the above is a dash syntax error (dash is default on ubuntu IIRC).

My $SHELL is /bin/bash:

$ bash --version
GNU bash, version 3.2.13(1)-release (x86_64-pc-linux-gnu)
Copyright (C) 2005 Free Software Foundation, Inc.
$


> Is it truly protable with "=" or do we need to be more clever?

I don't know how you managed to get it to work wtih "==".
String equality should be "=" in all /bin/sh versions.
It's been that way since it was written in pseudo-Algol.

- Dave

