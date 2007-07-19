Return-Path: <linux-kernel-owner+w=401wt.eu-S965334AbXGSQsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965334AbXGSQsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937872AbXGSQsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:48:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:6311 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933233AbXGSQsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:48:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bfjy3ApXCSzD3H82Qc/61BVPfpPMgmNjZdEQfoy6CsoztlyRridRJ0tKoOH/EMwCaCKBgM6JeQhmcqntq1Qju4WL5UB+rthkuUrObK6sC5BFOAPsX55GBrgz7OTmYNUlDo89MHQN3Stk2go5Ca2Yz/Xilxi2NNMZPCVMk6eooy4=
Message-ID: <91b13c310707190948j4eee14eauf53dd1c72c7fdb8a@mail.gmail.com>
Date: Fri, 20 Jul 2007 00:48:29 +0800
From: "rae l" <crquan@gmail.com>
To: "Paul Clements" <paul.clements@steeleye.com>
Subject: Re: [PATCH 1/2] nbd: use list_for_each_entry_safe to make it more consolidated and readable
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Pavel Machek" <pavel@ucw.cz>, "Steven Whitehouse" <steve@chygwyn.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, debra <chdebra@gmail.com>
In-Reply-To: <91b13c310707190855h6fee9604pcc86b6712d2c76f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11848376711601-git-send-email-crquan@gmail.com>
	 <469F7F58.4080709@steeleye.com>
	 <91b13c310707190855h6fee9604pcc86b6712d2c76f8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/07, rae l <crquan@gmail.com> wrote:
> On 7/19/07, Paul Clements <paul.clements@steeleye.com> wrote:
> > Could you name "n" as "tmp" (as in the previous code) so that it's clear
> > that's only a temporary variable. Other than that, this looks good.
> Sure. I just use the name "n" as in the declaration of
> list_for_each_entry_safe in the header file <linux/list.h>
> I'll resend it a little later.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/block/nbd.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index c129510..86639c0 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -237,8 +237,7 @@ error_out:

 static struct request *nbd_find_request(struct nbd_device *lo, char *handle)
 {
-	struct request *req;
-	struct list_head *tmp;
+	struct request *req, *tmp;
 	struct request *xreq;
 	int err;

@@ -249,8 +248,7 @@ static struct request *nbd_find_request(struct
nbd_device *lo, char *handle)
 		goto out;

 	spin_lock(&lo->queue_lock);
-	list_for_each(tmp, &lo->queue_head) {
-		req = list_entry(tmp, struct request, queuelist);
+	list_for_each_entry_safe(req, tmp, &lo->queue_head, queuelist) {
 		if (req != xreq)
 			continue;
 		list_del_init(&req->queuelist);

-- 
Denis Cheng
Linux Application Developer

"One of my most productive days was throwing away 1000 lines of code."
 - Ken Thompson.
