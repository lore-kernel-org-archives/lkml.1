Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbXHXVgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbXHXVgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbXHXVgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:36:45 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53244 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbXHXVgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:36:44 -0400
Date: Fri, 24 Aug 2007 23:36:40 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ram Pai <linuxram@us.ibm.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fix export_report.pl
In-Reply-To: <20070824210451.GE30705@stusta.de>
Message-ID: <Pine.LNX.4.64.0708242331490.28540@fbirervta.pbzchgretzou.qr>
References: <20070824210451.GE30705@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 24 2007 23:04, Adrian Bunk wrote:
>This patch fixes an annoying bug of export_report.pl missing the usages 
>of some exports.
>
>Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
>---
>
>This patch has been sent on:
>- 14 Aug 2007
>
>--- a/scripts/export_report.pl
>+++ b/scripts/export_report.pl
>@@ -112,7 +112,7 @@ foreach my $thismod (@allcfiles) {
> 			next;
> 		}
> 		if ($state eq 2) {

Perl: == for numbers, eq for strings.
SH:   == for strings, -eq for numbers.
PHP:  == for everything.


>-			if ( $_ !~ /0x[0-9a-f]{7,8},/ ) {
>+			if ( $_ !~ /0x[0-9a-f]+,/ ) {

I have not looked closer at it, but this looks like it should be
/0x[0-9a-fA-F]+,/  or
/0x[0-9a-f]+,/i

> 				next;
> 			}
> 			my $sym = (split /([,"])/,)[4];
>

	Jan
-- 
