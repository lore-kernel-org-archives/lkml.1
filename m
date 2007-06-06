Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbXFFQPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbXFFQPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbXFFQPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:15:10 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:7888 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbXFFQPG (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:15:06 -0400
Message-ID: <4666DD88.5030708@de.ibm.com>
Date: Wed, 06 Jun 2007 18:15:04 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Jared Hulbert <jaredeh@gmail.com>,
       carsteno@de.ibm.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
References: <1179871779.24163.11.camel@localhost.localdomain> <20070522154905.1d7e8a2e.akpm@linux-foundation.org> <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au> <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com> <20070606113351.GA11701@infradead.org>
In-Reply-To: <20070606113351.GA11701@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> I might be a little late in the discussion, but I somehow missed this
> before.  Please don't add this xip support to cramfs, because the
> whole point of cramfs is to be a simple _compressed_ filesystem,
> and we really don't want to add more complexity to it.  Please
> use something like the existing ext2 xip mode instead of add support
> to romfs using the generic filemap methods.
The clear advantage of using cramfs on embedded platforms over using the
ext2 stuff is, that one can choose per-file whether it should be
compressed or xip.
The real key is, to put both our ext2 stuff and the cramfs xip on a 
common infrastructure. They should use the same file operations and 
adress space operations for xip files rather then replicating each 
others bugs.
If cramfs shall be kept simple, it might be time to fork that file 
system. I don't see that need arise from the proposed solution. It can 
become clean and sane with a little work on it. Look at the xip 
extensions for ext2 for example, they don't bloat the filesystem too much.

so long,
Carsten
