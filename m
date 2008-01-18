Return-Path: <linux-kernel-owner+w=401wt.eu-S1761277AbYARXo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277AbYARXo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 18:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbYARXou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 18:44:50 -0500
Received: from khc.piap.pl ([195.187.100.11]:46289 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757260AbYARXot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 18:44:49 -0500
To: =?iso-8859-2?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: "Linux-Kernel\, " <linux-kernel@vger.kernel.org>
Subject: Re: Why is the kfree() argument const?
References: <MDEHLPKNGKAHNMBLJOLKOEIPJJAC.davids@webmaster.com>
	<alpine.LFD.1.00.0801171710160.2957@woody.linux-foundation.org>
	<47905A95.4030500@cateee.net> <47906133.6010301@cateee.net>
	<4790AF68.8040403@myrealbox.com>
	<20080118172428.GB61848@dspnet.fr.eu.org>
	<20080118232911.22c9d8d5@werewolf>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 19 Jan 2008 00:44:46 +0100
In-Reply-To: <20080118232911.22c9d8d5@werewolf> ("J. A. =?iso-8859-2?Q?Mag?=
 =?iso-8859-2?Q?all=F3n=22's?= message of "Fri\, 18 Jan 2008 23\:29\:11
 +0100")
Message-ID: <m3ve5qk8b5.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J.A. Magallón" <jamagallon@ono.com> writes:

> That's what __attribute__ ((pure)) is for, but if none of the
> functions is pure, the compiler can not be sure about side effects
> and can not reorder things. Don't forget that functions can do
> anything apart from mangling with their arguments.

Though it seems it could legally transform:

void kfree(const int *x);

{
int v, *ptr = malloc(sizeof(int));
*ptr = 51;
v = *ptr;
kfree(ptr);
printf("%d", v);

into:

{
int v, *ptr = malloc(sizeof(int));
*ptr = 51;
kfree(ptr);
v = *ptr;
printf("%d", v);
}

if it knows that malloc generates unaliased pointers, which seems
reasonable in general.
-- 
Krzysztof Halasa
