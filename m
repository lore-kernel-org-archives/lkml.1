Return-Path: <linux-kernel-owner+w=401wt.eu-S935927AbXHGWMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935927AbXHGWMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938073AbXHGWFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:05:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49091 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938069AbXHGWFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:05:32 -0400
Message-ID: <46B8ECA7.3000300@garzik.org>
Date: Tue, 07 Aug 2007 18:05:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: paul.pinault@disk91.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Data corruption
References: <200708072007.27343.paul.pinault@disk91.com>
In-Reply-To: <200708072007.27343.paul.pinault@disk91.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

paul wrote:
> Since 2-3 month I have some random data corruption on my Linux server, after 
> checking disks independently (i'm using raid1on 2 sata disk, the problem is 
> the same w/o raid) and memory, hardware simce to be out of cause...
> 
> Here is my problem:
> => head --bytes=300m  /dev/urandom > test
> => for i in `seq 0 9` ; do cp test test$i ; done
> => md5sum test*
> I got : 
> 014666c728c9e3b8299579fae499864a  test
> 014666c728c9e3b8299579fae499864a  test0
> 333fd93d093ac612cd8d5f65628f734e  test1
> 1ab6ee68c6a7d9ff5a05f9d63f0f6df6  test2
> 96e96483e3175a59c9c05b6720514e1e  test3
> 014666c728c9e3b8299579fae499864a  test4
> b24dbccc9f4831f8825ab4a55a3be4aa  test5
> 8493efc9c14e4b5c162ac23696fbc16a  test6
> 6a5f4301f66d0379049d79d0e14e2a87  test7
> 2c81cfa1c3a03aba134574922ee5d75c  test8
> 2ea15c8392bfd0123472a80125bb3abe  test9
> 
> ^^^ that sounds really bad for my data :(
> 
> ===================================================================
> I did some tests :
> * badblocks on the two disk with ro and rw tests => report no error
> * memtest during 6 hours => report no error
> 
> * I reproduces the error
>   - under xen client host (first time issue)
>   - under xen hypervisor
>   - under basic kernel with raid mirroring + ext3 and raiserfs
>   - under basic kernel w/o raid but ext3 ans reiserfs
> 
> My configuration
>  * Asus P5B-VM
>  * 4 Gb [try with and w/o options memory remaping]
>  * Intel Core 2 Duo [normal speed and underclocked(233 bus speed)]
>  * Hd SATA WD 80Gb

Corruption with which controller?  pata_jmicron? ata_piix? ahci?

Can you reproduce with 2.6.23-rc2?  If not, please report the bug to 
OpenSuSE, since we only support unmodified vanilla kernels here.

	Jeff



