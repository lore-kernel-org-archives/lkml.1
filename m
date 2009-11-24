Return-Path: <linux-kernel-owner+w=401wt.eu-S932964AbZKXNsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964AbZKXNsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932941AbZKXNsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:48:41 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:53626 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030AbZKXNsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:48:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=vxTj7aFnzO2KOzJMPgxZiOZEC3ABf2jEvZOsJ6Wt5FY6tpnqLFWVIKZM5W4BZVjcFk
         3iGGbF7/5tp3gFpEAwRBa12oqnl1HBv0stVQGC3/j+v3u78pF0C9Y+TIcOJngvNK6HFY
         5eFM/F/8hW/UXvMe3+wK6i11N4bH4XpC4tItg=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 0/4] cfq-iosched: policy fixes
Date: Tue, 24 Nov 2009 14:48:29 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911241448.29871.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,
I've collected some bugfixes to the for-2.6.33 branch.
Excluding the NCQ policy fix, that I'm resending with improved changelog,
the bugs were found by Vivek while investingating performance drops
or unfairness while testing cgroups. Nevertheless, those fixes have
general impact, so they should go in before cgroup code is merged:
* no-idle preemption logic was both under/over preempting.
   it should preempt only if the active queue is idling due to
   no-idle service tree empty
* seeky queues with large depth could steal too much bandwidth to
   low depth ones, so they will be marked as idling, and have exclusive
   access to disk for their time share
* the idling logic had some corner cases in which idling was not enabled,
  even if it should have been, caused by rq_noidle and rq_in_driver checks.
  Those were adjusted to better match the original intention.

Corrado
