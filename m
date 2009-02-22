Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbZBVPSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbZBVPSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 10:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbZBVPS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 10:18:27 -0500
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:53141 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbZBVPS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 10:18:27 -0500
Message-ID: <49A16CBB.5060600@numericable.fr>
Date: Sun, 22 Feb 2009 16:18:19 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: casey@schaufler-ca.com, paul.moore@hp.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][SMACK] convert smack rule list to linux list
References: <49A13E15.6020509@numericable.fr>	<200902222040.CAB86425.VMOQHFFFtOSLOJ@I-love.SAKURA.ne.jp>	<49A14FBE.7020206@numericable.fr> <200902222231.BDI18760.JFFLOQHMFOOSVt@I-love.SAKURA.ne.jp>
In-Reply-To: <200902222231.BDI18760.JFFLOQHMFOOSVt@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> etienne wrote:
>> what's the best way, using a rcu variant for "list_for_each, container_of ...etc" ?
>> (concurrent list insertion are already protected with a mutex, so rcu must the good idea for the read side) 
> Read side will need a read lock.
> I think you need to change from "mutex" to "rw_semaphore" (on the assumption
> that SMACK is safe against read locks that may sleep.  If not, change from
> "mutex" to "rw_spinlock").
> 
> Regards.
> 
or a rcu_read_lock?
since it disables preemption it means no user process will be able to change the list while it's read?

regards,
Etienne

 
