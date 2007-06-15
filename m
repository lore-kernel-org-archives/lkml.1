Return-Path: <linux-kernel-owner+w=401wt.eu-S1756421AbXFOT5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421AbXFOT5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbXFOT5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:57:44 -0400
Received: from poll.devit.com ([216.165.189.132]:57709 "EHLO mx0.devit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751794AbXFOT5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:57:43 -0400
Date: Fri, 15 Jun 2007 14:57:23 -0500
From: "David M. Lloyd" <dmlloyd@flurg.com>
To: "David M. Lloyd" <dmlloyd@flurg.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] Optimize is_power_of_2().
Message-ID: <20070615145723.7aa7aaa0@localhost>
In-Reply-To: <20070615145420.3a824477@localhost>
References: <1181926602.25193.5.camel@grianne>
	<Pine.LNX.4.64.0706152140171.32724@fbirervta.pbzchgretzou.qr>
	<20070615145420.3a824477@localhost>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007 14:54:20 -0500
"David M. Lloyd" <dmlloyd@flurg.com> wrote:

> On Fri, 15 Jun 2007 21:47:50 +0200 (CEST)
> Jan Engelhardt <jengelh@computergmbh.de> wrote:
> 
> > On Jun 15 2007 18:56, Vegard Nossum wrote:
> > > bool is_power_of_2(unsigned long n)
> > > {
> > >-	return (n != 0 && ((n & (n - 1)) == 0));
> > >+	return n * !(n & (n - 1));
> > > }
> > 
> > There is a third way which uses neither * nor &&, but []:
> 
> I assume using something GCC-specific is right out?
> 
> bool is_power_of_to(unsigned long n)
> {
> 	return __builtin_ffsl(n) == 1;

Pretend I typed this instead:

bool is_power_of_2(unsigned long n)
{
	return __builtin_popcountl(n) == 1;
}

All I can say is, it's really hot here :P

- DML
