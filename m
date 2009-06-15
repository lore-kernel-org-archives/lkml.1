Return-Path: <linux-kernel-owner+w=401wt.eu-S1762828AbZFOP1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762828AbZFOP1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762540AbZFOP12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:27:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:41765 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762468AbZFOP11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:27:27 -0400
Subject: Re: [PATCH v2 0/8] clean up vdso-layout.lds.S
From: Petr Tesarik <ptesarik@suse.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
In-Reply-To: <1245079002.17481.118.camel@nathan.suse.cz>
References: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
	 <20090612180626.GB18203@uranus.ravnborg.org>
	 <1245079002.17481.118.camel@nathan.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Mon, 15 Jun 2009 17:27:29 +0200
Message-Id: <1245079649.17481.121.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Tesarik píše v Po 15. 06. 2009 v 17:16 +0200:
> [...]
> An example can probably explain it better:
> 
> $ cat >shared.c <<EOF
> int shared_object[100];
> EOF
> $ cat >exe.c <<EOF
> #include <stdio.h>
> extern int shared_object[100];
> int main(void) {
> 	printf("%p\n", &shared_object); 
> 	return 0;
> }
> EOF

BTW this example demonstrates that there is one section which should be
included in .data but is not:

	*(COMMON)

I'll send a patch later.

Petr Tesarik

