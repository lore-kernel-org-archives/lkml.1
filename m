Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYHFMwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYHFMwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbYHFMun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:50:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:61029 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbYHFMum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:50:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=hqWzZMDyrhtLdeID7AID5OtjtH9sVUsNxtAcsaV2544Etqz/RbEqXN7fvEbzHKsUKb
         uCwm3VdSIs0HuCedcbsaEI7Zt4GzjTt4eKKyyNfuLpR4zpYmp67sVuzPP8l6ykZVMH7G
         BZsJ0mFHrQAznJ7nkoiJB7ETp/Uu4IpqmEyW4=
Message-ID: <b9df5fa10808060550y483d1c1dh99bac10c158510df@mail.gmail.com>
Date: Wed, 6 Aug 2008 18:50:37 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: pj@sgi.com, menage@google.com
Subject: [PATCH] cpuset.c : Removes extra variable
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone, the following patch removes the use of int
cpus_nonempty variable from 'update_flag' function.

Thanks.

Signed-off-by: Md.Rakib H. Mullick (rakib.mullick@gmail.com)

--- linux-2.6.27-rc2.orig/kernel/cpuset.c	2008-08-06 16:23:26.000000000 +0600
+++ linux-2.6.27-rc2/kernel/cpuset.c	2008-08-06 18:03:50.000000000 +0600
@@ -1110,7 +1110,7 @@ static int update_flag(cpuset_flagbits_t
 {
 	struct cpuset trialcs;
 	int err;
-	int cpus_nonempty, balance_flag_changed;
+	int balance_flag_changed;

 	trialcs = *cs;
 	if (turning_on)
@@ -1122,7 +1122,6 @@ static int update_flag(cpuset_flagbits_t
 	if (err < 0)
 		return err;

-	cpus_nonempty = !cpus_empty(trialcs.cpus_allowed);
 	balance_flag_changed = (is_sched_load_balance(cs) !=
 		 			is_sched_load_balance(&trialcs));

@@ -1130,7 +1129,7 @@ static int update_flag(cpuset_flagbits_t
 	cs->flags = trialcs.flags;
 	mutex_unlock(&callback_mutex);

-	if (cpus_nonempty && balance_flag_changed)
+	if (!cpus_empty(trialcs.cpus_allowed) && balance_flag_changed)
 		rebuild_sched_domains();

 	return 0;
