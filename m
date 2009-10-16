Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbZJPX2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbZJPX2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 19:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbZJPX2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 19:28:45 -0400
Received: from lucidpixels.com ([75.144.35.66]:44601 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbZJPX2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 19:28:44 -0400
Date: Fri, 16 Oct 2009 19:28:28 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: adam radford <aradford@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 3ware 9650SE-4PML RAID-1 Question: One reader process starves
 I/O  to the rest of the system?
In-Reply-To: <b1bc6a000910161536j2f9e273dy84b3d4f5098ff0d4@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0910161909340.7357@p34.internal.lan>
References: <alpine.DEB.2.00.0910161741110.11211@p34.internal.lan> <b1bc6a000910161536j2f9e273dy84b3d4f5098ff0d4@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 Oct 2009, adam radford wrote:

> Justin,
>
> Can you try turning down the queue depth of the disk that is getting
> written to to see if that resolves your responsiveness issue?
>
> I.E.:     echo "16" > /sys/block/sdX/device/queue_depth
>
> (replace X with disk letter of device from /raid6 mountpoint).
>
> FYI:   It's probably better to send questions like this to linux-scsi rather
>         than linux-kernel.
>
> -Adam
>

Hi,

Will do in the future for related queries, I set it to 16, its almost usable,
I set it to 8-- both are a bit slow during a dd read but at least it does not 
starve processes anymore to the point of failure, e.g.:

Oct 16 18:17:18 p34 amavis[12685]: (12685-10) (!)SA TIMED OUT, backtrace: at /usr/share/perl5/Mail/SpamAssassin/BayesStore/DBM.pm line 1855\n\teval {...} called at /usr/share/perl5/Mail/SpamAssassin/BayesStore/DBM.pm line 1855\n\tMail::SpamAssassin::BayesStore::DBM::tok_unpack('Mail::SpamAssassin::BayesStore::DBM=HASH(0x4bf2400)', '\\x{0}\\x{97}\\x{0}\\x{0}\\x{0}\\x{e2}\\x{3}\\x{0}\\x{0}k\\x{af}\\x{d8}J') called at /usr/share/perl5/Mail/SpamAssassin/BayesStore/DBM.pm line 865\n\tMail::SpamAssassin::BayesStore::DBM::tok_get_all('Mail::SpamAssassin::BayesStore::DBM=HASH(0x4bf2400)', '\\x{e5}a\\x{96}\\x{ce} ', '\\x{b3}]\\x{5}\\x{13}\\x{dd}', 'd\\x{b7}\\x{88}\\x{f2}%', '\\x{da}\\x{1}\\x{d4}/T', '\\x{fe}\\x{18}\\x{c6}\\x{d0}_', 'J\\x{9}\\x{9b}\\x{9a} ', 'l\\x{ce}p\\x{92}Y', '\\x{b8}\\x{8e}\\x{cc}z\\x{b3}', ...) called at /usr/share/perl5/Mail/SpamAssassin/Bayes.pm line 1185\n\tMail::SpamAssassin::Bayes::scan('Mail::SpamAssassin::Bayes=HASH(0x214b4e0)', 'Mail::SpamAssassin::PerMsgS
 t[...]

Thank you!

Justin.

