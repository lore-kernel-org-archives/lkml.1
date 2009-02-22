Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZBVNbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZBVNbd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 08:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbZBVNbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 08:31:23 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:58512 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbZBVNbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 08:31:22 -0500
To: etienne.basset@numericable.fr
Cc: casey@schaufler-ca.com, paul.moore@hp.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][SMACK] convert smack rule list to linux list
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <49A13E15.6020509@numericable.fr>
	<200902222040.CAB86425.VMOQHFFFtOSLOJ@I-love.SAKURA.ne.jp>
	<49A14FBE.7020206@numericable.fr>
In-Reply-To: <49A14FBE.7020206@numericable.fr>
Message-Id: <200902222231.BDI18760.JFFLOQHMFOOSVt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 22 Feb 2009 22:31:20 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

etienne wrote:
> what's the best way, using a rcu variant for "list_for_each, container_of ...etc" ?
> (concurrent list insertion are already protected with a mutex, so rcu must the good idea for the read side) 
Read side will need a read lock.
I think you need to change from "mutex" to "rw_semaphore" (on the assumption
that SMACK is safe against read locks that may sleep.  If not, change from
"mutex" to "rw_spinlock").

Regards.
