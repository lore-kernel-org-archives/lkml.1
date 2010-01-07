Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697Ab0AGOCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab0AGOCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 09:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662Ab0AGOCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 09:02:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55695 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab0AGOCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 09:02:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: strict copy_from_user checks issues?
Date: Thu, 7 Jan 2010 15:02:29 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com> <201001051620.38943.arnd@arndb.de> <4B43B2D7.6000208@zytor.com>
In-Reply-To: <4B43B2D7.6000208@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001071502.29777.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+umsX/eGSJCMlJUehKAsI+i9EHy1hzZDyUmO+
 uMQgwzLX5p6RMY/9nlTp0SXFc+mKJESHcaLs+pITgdF4BnVjve
 ePdoR9A3GwBFBl12JH+Ug==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 January 2010, H. Peter Anvin wrote:
> What's much worse is that it adds churn to an otherwise-tested code path.
> 
> We almost need a copy_from/to_user_audited() to override the warning.
> Not that errors can't creap back in...
> 

Maybe just splitting it up into access_ok() and __copy_from_user(),
plus a comment is enough? That way we don't need to add another interface
for the rare case.

On a related topic, one interface that may actually be worth adding is
a get_user/put_user variant that can operate on full data structures
and return -EFAULT on failure rather than the number of remaining
bytes that 99% of the code never need.

	Arnd
