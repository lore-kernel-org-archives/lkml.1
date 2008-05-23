Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbYEWIsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbYEWIsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 04:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYEWIsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 04:48:07 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:41459 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYEWIsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 04:48:06 -0400
Message-ID: <48368466.5040600@s5r6.in-berlin.de>
Date: Fri, 23 May 2008 10:46:30 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Push ioctl BKL down into the i2c code
References: <20080522222327.1af72794@core> <20080523093545.175c769c@hyperion.delvare>
In-Reply-To: <20080523093545.175c769c@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Thu, 22 May 2008 22:23:27 +0100, Alan Cox wrote:
>> Signed-off-by: Alan Cox <alan@redhat.com>
>> 
> 
> Description of what the patch does and why it is needed, please. I
> can't apply it without that. My first impression is a patch making the
> code bigger and more complex with no obvious benefit ;)

I wasn't asked, but:

The patch description was factored out.  ;-)
http://lkml.org/lkml/2008/5/22/333

AFAIU it's a preparation for

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ ?? @@ struct file_operations {
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
-	int (*ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);

Obvious benefits:
  - No new .ioctl()s.
  - Heads up for subsystem people:  "Did you know you are taking the BKL?
    You probably don't need to, and you definitely don't want to."
-- 
Stefan Richter
-=====-==--- -=-= =-===
http://arcgraph.de/sr/
