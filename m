Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbYAOQnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbYAOQnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 11:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYAOQnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 11:43:08 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:52818 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYAOQnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:43:06 -0500
Date: Tue, 15 Jan 2008 17:43:05 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
cc: =?ISO-8859-15?Q?Dagfinn_Ilmari_Manns=E5ker?= <ilmari@ilmari.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Possibly silly Q?
In-Reply-To: <alpine.LFD.1.00.0801141551260.26152@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0801151741450.30034@fbirervta.pbzchgretzou.qr>
References: <200801141434.00934.gene.heskett@gmail.com> <d8jmyr8xjyi.fsf@nygaard.ping.uio.no>
 <alpine.LFD.1.00.0801141551260.26152@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 14 2008 15:53, Robert P. J. Day wrote:
>>
>> fdisk or similar should have issued an ioctl to reread the partition
>> table after writing the new one, but you can do it manually with
>> 'blockdev --rereadpt <device>'.
>
>i remember bringing up this very issue quite some time ago and, IIRC,
>the consensus was that *primary* partition changes would be re-read by
>the kernel, but not *logical* partition changes.  or something sort of
>like that.

Nah, it dumps the whole partition structure.
Note in fs/partition/check.c:rescan_partitions:

	for (p = 1; p < disk->minors; p++)
		delete_partition(disk, p);
