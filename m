Return-Path: <linux-kernel-owner+w=401wt.eu-S1762046AbXJEL7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762046AbXJEL7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 07:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbXJEL7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 07:59:45 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39314 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbXJEL7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 07:59:44 -0400
Date: Fri, 5 Oct 2007 13:59:42 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Matthew Wilcox <matthew@wil.cx>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] isofs: add +w bit for non-RR discs
In-Reply-To: <20071005024602.GU12049@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0710051358440.13406@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710021958230.7130@fbirervta.pbzchgretzou.qr>
 <20071005024602.GU12049@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 4 2007 20:46, Matthew Wilcox wrote:
>On Tue, Oct 02, 2007 at 08:00:26PM +0200, Jan Engelhardt wrote:
>> Add %S_IWUGO bit for files on ISO-9660 filesystems without RockRidge
>
>Looks to me like you've added S_IWUSR, not S_IWUGO.

Yes, S_IWUSR it should be, and is. When a user copies such a file,
the new file will be owned by him/her, so the +w bit needs to
be S_IWUSR indeed.

>> -	popt->mode = S_IRUGO | S_IXUGO; /*
>> +	popt->mode = S_IRUGO | S_IWUSR | S_IXUGO;
>> -		inode->i_mode = S_IRUGO | S_IXUGO | S_IFDIR;
>> +		inode->i_mode = S_IRUGO | S_IWUSR | S_IXUGO | S_IFDIR;
>
