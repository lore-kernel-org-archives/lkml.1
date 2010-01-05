Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468Ab0AELgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab0AELgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211Ab0AELgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:36:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:65347 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab0AELgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:36:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH] BUG(): CONFIG_BUG=n version of BUG() should be unreachable()
Date: Tue, 5 Jan 2010 12:35:44 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Alexander Beregalov <a.beregalov@gmail.com>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, sam@ravnborg.org,
       dhowells@redhat.com
References: <1261531032-15225-1-git-send-email-a.beregalov@gmail.com> <200912302012.05827.arnd@arndb.de> <4B422E0C.1070108@caviumnetworks.com>
In-Reply-To: <4B422E0C.1070108@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001051235.45568.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/K5QMCqwWVcS1+6Hk9Z67RhIPg0NRkiAr0dCC
 RaBVkbn6gYdteJq1IM3UO1UtH21GT9ydGoC26PRT0JuNmRUNrz
 emI/Bv1kmOQVT0KK8AB6g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 January 2010, David Daney wrote:
> Arnd Bergmann wrote:
> > The alternative "do { } while (1)" is not ideal, because an
> > endless loop still requires more code (typically one instruction)
> > than doing nothing at all.
> > 
> 
> Well "do { } while (1)" is exactly the expansion of unreachable() for 
> GCC < 4.5.  Since GCC-4.5 has not been released yet, most people will 
> get these extra looping instructions if you change BUG in this way.

Yes, that is why I wrote the final paragraph, saying
 
> > If there are only than a handful of places that actually cause a warning,
> > using "do { } while (0)" (or __builtin_unreachable where available) and
> > fixing up the code using it might be better.

	Arnd
