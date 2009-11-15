Return-Path: <linux-kernel-owner+w=401wt.eu-S1751888AbZKOVvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbZKOVvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 16:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbZKOVvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 16:51:44 -0500
Received: from de01.mail.all-tld.net ([195.140.232.8]:56540 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZKOVvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 16:51:43 -0500
Date: Sun, 15 Nov 2009 22:51:30 +0100
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH v5 10/12] string: factorize skip_spaces and export it to
 be generally available
To: Anonymous <aim0shei@lavabit.com>
Cc: =?iso-8859-1?b?QW5kcuk=?= Goddard Rosa <andre.goddard@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20091115200215.GA25351@machine> (from aim0shei@lavabit.com on
	Sun Nov 15 21:02:15 2009)
X-Mailer: Balsa 2.3.21
Message-Id: <1258321890l.9645l.1l@oscar.alarsen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
References: <20091115200215.GA25351@machine>
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-11-15 21:02:15, Anonymous wrote:
> On Sun, Nov 15, 2009 at 08:33:29PM +0100, Anders Larsen wrote:
> > On 2009-11-15 08:15:03, André Goddard Rosa wrote:
> > >+char *skip_spaces(const char *str)
> > >+{
> > >+	while (isspace(*str))
> > >+		++str;
> > >+	return (char *)str;
> > >+}
> >> Is there a good reason why the parameter 'str' is declared 'const'
> > when skip_spaces() returns a non-const pointer into str ?
> >Declaring return value as const won't let us modificate string after
> skipping spaces. Declaring parameter as non-const won't let us
> giving (const char *) to this function. So i think it is ok.

skip_spaces() _implicitly_ casts away the 'const' of the parameter,
which may come as a (nasty) surprise to users of the function.

Consider this (contrieved and buggy) example:

	const char* my_string = " do not modify me! ";
	char* result = strcat(skip_spaces(my_string, "boom!"));

The proposed implementation of skip_spaces() effectively prevents
the compiler from catching this obvious bug.

Cheers
Anders
