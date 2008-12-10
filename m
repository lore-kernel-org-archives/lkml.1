Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbYLKUFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbYLKUFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756541AbYLKUFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:05:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:59713 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499AbYLKUFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:05:45 -0500
Message-ID: <49417296.25e2660a.2824.ffffc60b@mx.google.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Karsten Keil <kkeil@suse.de>
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
In-Reply-To: <49403C26.5050402@gmail.com>
References: <49403C26.5050402@gmail.com>
Date: Wed, 10 Dec 2008 20:41:55 +0100
Subject: Re: [PATCHv2 4/9] mISDN: fix sparse warning
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: un-export symbol 'plx_lock'

Fix this warning:

  drivers/isdn/hardware/mISDN/hfcmulti.c:176:1: warning: symbol 'plx_lock' shadows an earlier one
  drivers/isdn/hardware/mISDN/hfcmulti.c:175:19: originally declared here

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---

On Wed, Dec 10, 2008 at 11:01 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 12/10/2008 04:13 PM, Hannes Eder wrote:
>> Should 'plx_lock' be declared in a header file?  Or is it really
>> neccessart to export it?
>
> As there is no other user, I vote for unexporting it.

In that case patch number 4 looks like this:

 drivers/isdn/hardware/mISDN/hfcmulti.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 599d832..970201d 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -173,7 +173,6 @@ static int interrupt_registered;
 static struct hfc_multi *syncmaster;
 static int plxsd_master; /* if we have a master card (yet) */
 static spinlock_t plx_lock; /* may not acquire other lock inside */
-EXPORT_SYMBOL(plx_lock);
 
 #define	TYP_E1		1
 #define	TYP_4S		4
-- 
1.5.6.3

