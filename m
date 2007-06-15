Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbXFOTr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbXFOTr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbXFOTrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:47:51 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:20655 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbXFOTrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:47:51 -0400
Date: Fri, 15 Jun 2007 21:47:50 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] Optimize is_power_of_2().
In-Reply-To: <1181926602.25193.5.camel@grianne>
Message-ID: <Pine.LNX.4.64.0706152140171.32724@fbirervta.pbzchgretzou.qr>
References: <1181926602.25193.5.camel@grianne>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Jun 15 2007 18:56, Vegard Nossum wrote:
> bool is_power_of_2(unsigned long n)
> {
>-	return (n != 0 && ((n & (n - 1)) == 0));
>+	return n * !(n & (n - 1));
> }

There is a third way which uses neither * nor &&, but []:

bool is_power_of_2(unsigned long n)
{
	static const bool yn[] = {
		[0] = false,
		[1 ... (8 * sizeof(n) - 1)] = true,
	};
	return yn[(n & (n - 1)) == 0];
}



	Jan
-- 
