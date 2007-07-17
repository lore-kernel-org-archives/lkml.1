Return-Path: <linux-kernel-owner+w=401wt.eu-S933651AbXGQPMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651AbXGQPMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbXGQPMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:12:34 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:45563 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752338AbXGQPMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:12:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:User-Agent:MIME-Version:Content-Disposition:Cc:Date:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=WIPZh8nXWJhFbu2MomGa9yw59dXvJpt/kO2RkkXEbBmHJd6FcbiDsO6aief80QdoJOfE4p5FtmaS7Rofmd+iIWEexT5tu8UfUWvmxmdT9ZO7k1aLTNxZgVyrd6t1Tk1OKTqmg9hqJq53oqlpSMeQC7sFlH45cuOWgvaKsSg6KnM=  ;
X-YMail-OSG: kN3TgZcVM1lemSqXhdHd62IB4jxiggTQjuc1KaXVP4hsQPDztIMNANp3BC1hOFHnc2Ae1UoNjA--
From: David Brownell <david-b@pacbell.net>
To: bcrl@kvack.org
Subject: [RESEND patch 2.6.22-rc2-git] AIO sparse fix (type of ki_flags)
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Disposition: inline
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Tue, 17 Jul 2007 07:03:57 -0700
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707170703.57917.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix type issue reported by latest 'sparse':  kiocb.ki_flags should
be "unsigned long" (not "long"), to match bitop type signature.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 include/linux/aio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- h4.orig/include/linux/aio.h	2007-05-19 11:40:45.000000000 -0700
+++ h4/include/linux/aio.h	2007-05-25 19:23:34.000000000 -0700
@@ -86,7 +86,7 @@ struct kioctx;
  */
 struct kiocb {
 	struct list_head	ki_run_list;
-	long			ki_flags;
+	unsigned long		ki_flags;
 	int			ki_users;
 	unsigned		ki_key;		/* id of this request */
 
