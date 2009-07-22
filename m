Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZGVN10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZGVN10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbZGVN1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:27:25 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54858 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbZGVN1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:27:25 -0400
X-Sasl-enc: vCpC/0dyqwa8BwEpMjnksBVkLwBooVjTH9xwrZsM9YOo 1248269244
Date: Wed, 22 Jul 2009 10:27:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Krzysztof Oledzki <olel@ans.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Troy Moure <twmoure@szypr.net>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net, Ian Lance Taylor <iant@google.com>
Subject: Re: Linux 2.6.27.27
Message-ID: <20090722132721.GA7390@khazad-dum.debian.net>
References: <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain>
 <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl>
 <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl>
 <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl>
 <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain>
 <alpine.LFD.2.01.0907211133010.19335@localhost.localdomain>
 <alpine.LFD.2.00.0907212211040.4630@troy-laptop>
 <alpine.LFD.2.01.0907211726140.19335@localhost.localdomain>
 <alpine.LNX.1.10.0907221340540.26357@bizon.gios.gov.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0907221340540.26357@bizon.gios.gov.pl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009, Krzysztof Oledzki wrote:
> BTW: here is a simple testcase for this bug:
> 
> --- fno-strict-overflow-fixed-bug.c ---
> #include <stdio.h>
> 
> int main() {
> 
>         unsigned char i;
> 
>         for (i = 0; i < 128; i++)
>                 printf("loop %u\n", i);
> 
>         return 0;
> }
> --- cut here ---
> 
> The code should be compiled with:
>  cc -o fno-strict-overflow-fixed-bug -Os -fno-strict-overflow fno-strict-overflow-fixed-bug.c
> or:
>  cc -o fno-strict-overflow-fixed-bug -O2 -fno-strict-overflow fno-strict-overflow-fixed-bug.c
> 
> This bug does not exist with -O1 or if the loop is controlled by "i
> < 127" or "i < 129".

Thank you.

Debian stable,   ia32, gcc 4.2.4-6:    BUG
Debian stable,   ia32, gcc 4.3.2-1.1:  no bug (default)

Debian unstable, ia32, gcc 4.2.4-6:    BUG
Debian unstable, ia32, gcc 4.3.3-14:   no bug (default)

Someone else already tested gcc 4.4.0, as no bug.

I will file bugs against Debian gcc-4.2...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
