Return-Path: <linux-kernel-owner+w=401wt.eu-S1161505AbXBOWSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161505AbXBOWSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161506AbXBOWSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:18:24 -0500
Received: from web43116.mail.sp1.yahoo.com ([216.252.121.16]:33503 "HELO
	web43116.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161505AbXBOWSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:18:24 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Feb 2007 17:18:23 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=aZkw5Z3j535xe9Ta3ELFyg7dw5FpBEtYe8EOLRWpZ3wDC32SksRbbAZZspS5UwDtIjkFldSZxTHA7+F1+gTSnlKguDbuSyE7Q8uvhgP5fwubKoDesgKDHSu6zX2hkMoO09Kcih5UG+GS3N0Hrc+8yFM214LlW8p6RkRpqhYm/H0=;
X-YMail-OSG: pwkLRAMVM1kdDQXWyU2PH2eWpNBZWv1cUuWT4uKB573jewIUQp6jL5pdZFqdSTE0eA--
Date: Thu, 15 Feb 2007 14:11:42 -0800 (PST)
From: Tim Cullen <timcullen2001@yahoo.com>
Subject: possible bug in page allocation mechanism
To: linux-kernel@vger.kernel.org
Cc: timcullen2001@yahoo.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <490976.56324.qm@web43116.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There appears to be a inconsistenancy with reference
counts on pages allocated with alloc_pages when order
is greater than zero. In buffered_rmqueue when order
!= 0 then __rmqueue is called. This returns a page
pointer that is really a pointer to the first page in
a group of pages. Subsequently prep_new_page is called
on the first page of the group but not on any others.
This results in the first page having a reference
count of 1 while all other pages in the allocation
have a reference count of 0. I would think that all
pages in the same allocation should all have the same
reference count at the end of the allocation.

I've looked at this in the 2.6.20, 2.6.19.1, and the
2.6.17.7 kernels. They contain the same code in this
area.

I don't have a solution to offer, but I wanted to
bring it to the attention of those who have more
knowledge about the workings of the page allocation
system.

tim



 
____________________________________________________________________________________
Don't pick lemons.
See all the new 2007 cars at Yahoo! Autos.
http://autos.yahoo.com/new_cars.html 
