Return-Path: <linux-kernel-owner+w=401wt.eu-S1760394AbXEXBFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760394AbXEXBFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756954AbXEXBFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:05:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:48292 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825AbXEXBFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d6QdDW7oqJJugfa2tctRJV+YGiWCqrJkfwF/aUmhWDtCoOtNCSsbbBnlfkuSk/wCf39KkZK6DJU1A/gxYacxhjXJYoT4Uv51sVlwfihE2cpcq8QRdHSgrIuf4vJMYR4+YG63t+bjqSwQHu7Hd+bG3fbiuX9EX3mVsz9NSSRnAKE=
Message-ID: <a8e1da0705231805j47fb7438k1a2f5926b20835f9@mail.gmail.com>
Date: Thu, 24 May 2007 01:05:03 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Steven French" <sfrench@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1 cifs_mount oops
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "David Kleikamp" <shaggy@us.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Shirish S Pargaonkar" <shirishp@us.ibm.com>
In-Reply-To: <OF5C2BA51B.B63E317D-ON872572E4.00793F56-862572E4.007A3D2C@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070523091013.b1475211.akpm@linux-foundation.org>
	 <OF5C2BA51B.B63E317D-ON872572E4.00793F56-862572E4.007A3D2C@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have one problem about this:  after the srvTcp->tsk is set to NULL
(maybe the thread is  still there, isn't it?), is the kthread still
needed to be stopped by calling kthread_stop()? If it is true, then
the task_struct should be saved before send_sig like my patch:

                        if (srvTcp->tsk) {
+                               struct task_struct * tsk = srvTcp->tsk;
                               send_sig(SIGKILL,srvTcp->tsk,1);
-                               kthread_stop(srvTcp->tsk);
+                               kthread_stop(tsk);

Regards
dave
